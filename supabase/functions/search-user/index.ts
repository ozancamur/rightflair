import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface SearchUsersRequest {
  query: string;
  page?: number;
  limit?: number;
}

interface UserResult {
  id: string;
  username: string;
  full_name: string | null;
  profile_photo_url: string | null;
}

interface SearchUsersResponse {
  success: boolean;
  data?: {
    users: UserResult[];
    pagination: {
      page: number;
      limit: number;
      total_count: number;
      total_pages: number;
      has_next: boolean;
      has_prev: boolean;
    };
  };
  error?: string;
}

function errorResponse(message: string, status: number): Response {
  const body: SearchUsersResponse = { success: false, error: message };
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function successResponse(data: SearchUsersResponse["data"]): Response {
  const body: SearchUsersResponse = { success: true, data };
  return new Response(JSON.stringify(body), {
    status: 200,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

// ============================================
// Kullanıcının etkileşime girdiği user ID'leri getirir
// Sıralama: en son etkileşim tarihi (DESC)
// ============================================
async function getInteractedUserIds(
  supabase: ReturnType<typeof createClient>,
  userId: string
): Promise<string[]> {
  try {
    // 1. Kullanıcının katıldığı conversation ID'lerini çek
    const { data: participantRows } = await supabase
      .from("conversation_participants")
      .select("conversation_id")
      .eq("user_id", userId);

    const conversationIds = (participantRows ?? []).map(
      (r: any) => r.conversation_id
    );

    // Paralel sorgular
    const promises: Promise<any>[] = [];

    // 2. DM mesajları — conversation ID'leri varsa
    if (conversationIds.length > 0) {
      promises.push(
        supabase
          .from("messages")
          .select("sender_id, created_at")
          .neq("sender_id", userId)
          .in_("conversation_id", conversationIds)
          .order("created_at", { ascending: false })
          .limit(100)
      );
    } else {
      promises.push(Promise.resolve({ data: [] }));
    }

    // 3. Takip ilişkileri
    promises.push(
      supabase
        .from("follows")
        .select("follower_id, following_id, created_at")
        .or(`follower_id.eq.${userId},following_id.eq.${userId}`)
        .order("created_at", { ascending: false })
        .limit(100)
    );

    // 4. Yorumlar — kullanıcının postlarına yorum yapanlar
    promises.push(
      supabase
        .from("comments")
        .select("user_id, created_at, posts!inner(user_id)")
        .or(`user_id.eq.${userId},posts.user_id.eq.${userId}`)
        .order("created_at", { ascending: false })
        .limit(100)
    );

    // 5. Post beğenileri — kullanıcının postlarını beğenenler
    promises.push(
      supabase
        .from("post_likes")
        .select("user_id, created_at, posts!inner(user_id)")
        .eq("posts.user_id", userId)
        .neq("user_id", userId)
        .order("created_at", { ascending: false })
        .limit(100)
    );

    const [messagesResult, followsResult, commentsResult, likesResult] =
      await Promise.all(promises);

    type Interaction = { user_id: string; ts: string };
    const interactions: Interaction[] = [];

    // Messages
    for (const msg of messagesResult.data ?? []) {
      if (msg.sender_id) {
        interactions.push({ user_id: msg.sender_id, ts: msg.created_at });
      }
    }

    // Follows
    for (const f of followsResult.data ?? []) {
      const otherId =
        f.follower_id === userId ? f.following_id : f.follower_id;
      if (otherId) {
        interactions.push({ user_id: otherId, ts: f.created_at });
      }
    }

    // Comments
    for (const c of commentsResult.data ?? []) {
      const postOwnerId = (c as any).posts?.user_id;
      if (c.user_id !== userId && c.user_id) {
        interactions.push({ user_id: c.user_id, ts: c.created_at });
      } else if (postOwnerId && postOwnerId !== userId) {
        interactions.push({ user_id: postOwnerId, ts: c.created_at });
      }
    }

    // Post likes
    for (const l of likesResult.data ?? []) {
      if (l.user_id) {
        interactions.push({ user_id: l.user_id, ts: l.created_at });
      }
    }

    // Her kullanıcı için en son etkileşim tarihini bul
    const latestByUser = new Map<string, string>();
    for (const { user_id, ts } of interactions) {
      if (!user_id || user_id === userId) continue;
      const existing = latestByUser.get(user_id);
      if (!existing || ts > existing) {
        latestByUser.set(user_id, ts);
      }
    }

    return [...latestByUser.entries()]
      .sort((a, b) => (b[1] > a[1] ? 1 : -1))
      .map(([id]) => id);
  } catch (err) {
    console.error("getInteractedUserIds error:", err);
    return [];
  }
}

// ============================================
// MAIN HANDLER
// ============================================
serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return errorResponse("Method not allowed. Use POST.", 405);
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) return errorResponse("Authorization header required", 401);

    const supabaseAuth = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const {
      data: { user },
      error: authError,
    } = await supabaseAuth.auth.getUser();
    if (authError || !user) return errorResponse("Unauthorized", 401);

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    let body: SearchUsersRequest;
    try {
      body = await req.json();
    } catch {
      return errorResponse("Invalid JSON body", 400);
    }

    const { query, page: rawPage = 1, limit: rawLimit = 20 } = body;

    if (!query || typeof query !== "string" || query.trim().length === 0) {
      return errorResponse("query zorunludur", 400);
    }

    const cleanedQuery = query.trim().toLowerCase();
    if (cleanedQuery.length > 50)
      return errorResponse("query 50 karakterden uzun olamaz", 400);

    const page = Math.max(1, rawPage);
    const limit = Math.min(50, Math.max(1, rawLimit));
    const offset = (page - 1) * limit;
    const pattern = `%${cleanedQuery}%`;

    // ── 1. Eşleşen kullanıcıları çek ────────────────
    const {
      data: allUsers,
      error: usersError,
      count,
    } = await supabase
      .from("users")
      .select("id, username, full_name, profile_photo_url", { count: "exact" })
      .eq("status", "active")
      .neq("id", user.id)
      .or(`username.ilike.${pattern},full_name.ilike.${pattern}`)
      .range(offset, offset + limit - 1);

    if (usersError) {
      console.error("Users query error:", usersError);
      return errorResponse("Kullanıcı araması başarısız", 500);
    }

    if (!allUsers || allUsers.length === 0) {
      return successResponse({
        users: [],
        pagination: {
          page,
          limit,
          total_count: 0,
          total_pages: 0,
          has_next: false,
          has_prev: false,
        },
      });
    }

    // ── 2. Etkileşim geçmişini çek ──
    const interactedIds = await getInteractedUserIds(supabase, user.id);
    const interactionRankMap = new Map<string, number>();
    interactedIds.forEach((id, index) => interactionRankMap.set(id, index));

    // ── 3. Sırala: etkileşimliler önce, sonra alfabetik ──
    const sorted = [...allUsers].sort((a, b) => {
      const rankA = interactionRankMap.get(a.id);
      const rankB = interactionRankMap.get(b.id);

      const hasA = rankA !== undefined;
      const hasB = rankB !== undefined;

      if (hasA && hasB) return rankA - rankB;
      if (hasA) return -1;
      if (hasB) return 1;
      return a.username.localeCompare(b.username);
    });

    const userResults: UserResult[] = sorted.map((u) => ({
      id: String(u.id),
      username: String(u.username),
      full_name: u.full_name as string | null,
      profile_photo_url: u.profile_photo_url as string | null,
    }));

    const totalCount = count ?? 0;
    const totalPages = Math.ceil(totalCount / limit);

    return successResponse({
      users: userResults,
      pagination: {
        page,
        limit,
        total_count: totalCount,
        total_pages: totalPages,
        has_next: page < totalPages,
        has_prev: page > 1,
      },
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return errorResponse("Internal server error", 500);
  }
});
