import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/authentication/model/user.dart';
import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/base/model/response.dart';
import '../model/request_user_posts.dart';
import '../model/user_posts.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ApiService _api;
  final SupabaseClient _supabase;

  ProfileRepositoryImpl({ApiService? api})
    : _api = api ?? ApiService(),
      _supabase = Supabase.instance.client;

  @override
  Future<UserModel?> getUser() async {
    try {
      final request = await _api.get(Endpoint.GET_USER);
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final UserModel data = UserModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUser :> $e");
      return null;
    }
  }

  @override
  Future<UserPostsModel?> getUserPosts({
    required RequestUserPostsModel parameters,
  }) async {
    try {
      final request = await _api.get(
        Endpoint.GET_USER_POSTS,
        parameters: parameters.toJson(),
      );
      // ResponseModel wrapper'ı kaldırdık çünkü API direkt olarak posts ve pagination dönüyor
      final UserPostsModel data = UserPostsModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUserPosts :> $e");
      return null;
    }
  }

  @override
  Future<StyleTagsModel?> getUserStyleTags() async {
    try {
      final request = await _api.get(Endpoint.GET_USER_STYLE_TAGS);
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      final StyleTagsModel data = StyleTagsModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUserStyleTags :> $e");
      return null;
    }
  }

  @override
  Future<void> updateUser({String? profilePhotoUrl}) async {
    try {
      final Map<String, dynamic> data = {};
      if (profilePhotoUrl != null) data['profilePhotoUrl'] = profilePhotoUrl;

      if (data.isNotEmpty) {
        await _api.post(Endpoint.UPDATE_USER, data: data);
      }
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in updateUser :> $e");
    }
  }

  @override
  Future<String?> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final String fileExtension = imageFile.path.split('.').last;
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final String storagePath = '$userId/profile-photos/$fileName';

      await _supabase.storage
          .from('profile-photos')
          .upload(
            storagePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String publicUrl = _supabase.storage
          .from('profile-photos')
          .getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in uploadProfilePhoto :> $e");
      return null;
    }
  }
}
/*
// supabase/functions/get-my-posts/index.ts
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface PostResponse {
  id: string;
  post_image_url: string;
  description: string | null;
  location: string | null;
  is_anonymous: boolean;
  allow_comments: boolean;
  likes_count: number;
  dislikes_count: number;
  comments_count: number;
  saves_count: number;
  shares_count: number;
  view_count: number;
  popularity_score: number;
  mentioned_user_ids: string[] | null;
  created_at: string;
  updated_at: string;
  tags: string[];
}

interface PaginatedResponse {
  posts: PostResponse[];
  pagination: {
    page: number;
    limit: number;
    total_count: number;
    total_pages: number;
    has_next: boolean;
    has_previous: boolean;
  };
}

serve(async (req) => {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Supabase client oluştur
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Authorization header required" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    // Kullanıcıyı doğrula
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Query parametrelerini al
    const url = new URL(req.url);
    const page = Math.max(1, parseInt(url.searchParams.get("page") || "1"));
    const limit = Math.min(50, Math.max(1, parseInt(url.searchParams.get("limit") || "20")));
    const sortBy = url.searchParams.get("sort_by") || "created_at"; // created_at, popularity_score, view_count
    const sortOrder = url.searchParams.get("sort_order") || "desc"; // asc, desc

    // Geçerli sıralama alanlarını kontrol et
    const validSortFields = ["created_at", "updated_at", "popularity_score", "view_count", "likes_count"];
    const actualSortBy = validSortFields.includes(sortBy) ? sortBy : "created_at";
    const actualSortOrder = sortOrder === "asc";

    // Offset hesapla
    const offset = (page - 1) * limit;

    // Toplam post sayısını al (sadece published)
    const { count: totalCount, error: countError } = await supabase
      .from("posts")
      .select("*", { count: "exact", head: true })
      .eq("user_id", user.id)
      .eq("status", "published");

    if (countError) {
      console.error("Count error:", countError);
      return new Response(
        JSON.stringify({ error: "Failed to get total count" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Postları çek
    const { data: posts, error: postsError } = await supabase
      .from("posts")
      .select(`
        id,
        post_image_url,
        description,
        location,
        is_anonymous,
        allow_comments,
        likes_count,
        dislikes_count,
        comments_count,
        saves_count,
        shares_count,
        view_count,
        popularity_score,
        mentioned_user_ids,
        created_at,
        updated_at
      `)
      .eq("user_id", user.id)
      .eq("status", "published")
      .order(actualSortBy, { ascending: actualSortOrder })
      .range(offset, offset + limit - 1);

    if (postsError) {
      console.error("Posts error:", postsError);
      return new Response(
        JSON.stringify({ error: "Failed to fetch posts" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Her post için tag'leri çek
    const postIds = posts?.map(p => p.id) || [];
    let tagsMap: Record<string, string[]> = {};

    if (postIds.length > 0) {
      const { data: tags, error: tagsError } = await supabase
        .from("post_tags")
        .select("post_id, tag_name")
        .in("post_id", postIds);

      if (!tagsError && tags) {
        tagsMap = tags.reduce((acc, tag) => {
          if (!acc[tag.post_id]) {
            acc[tag.post_id] = [];
          }
          acc[tag.post_id].push(tag.tag_name);
          return acc;
        }, {} as Record<string, string[]>);
      }
    }

    // Response'u formatla
    const formattedPosts: PostResponse[] = (posts || []).map(post => ({
      ...post,
      tags: tagsMap[post.id] || [],
    }));

    const total = totalCount || 0;
    const totalPages = Math.ceil(total / limit);

    const response: PaginatedResponse = {
      posts: formattedPosts,
      pagination: {
        page,
        limit,
        total_count: total,
        total_pages: totalPages,
        has_next: page < totalPages,
        has_previous: page > 1,
      },
    };

    return new Response(
      JSON.stringify(response),
      { 
        status: 200, 
        headers: { ...corsHeaders, "Content-Type": "application/json" } 
      }
    );

  } catch (error) {
    console.error("Unexpected error:", error);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});*/