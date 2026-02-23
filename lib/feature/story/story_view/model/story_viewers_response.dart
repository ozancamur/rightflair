import 'package:rightflair/feature/main/feed/models/my_story_viewers.dart';

class StoryViewersResponse {
  final String? storyId;
  final String? mediaUrl;
  final String? mediaType;
  final String? createdAt;
  final String? expiresAt;
  final int totalViewCount;
  final List<MyStoryViewersModel> viewers;
  final StoryViewersPagination pagination;

  StoryViewersResponse({
    this.storyId,
    this.mediaUrl,
    this.mediaType,
    this.createdAt,
    this.expiresAt,
    this.totalViewCount = 0,
    this.viewers = const [],
    this.pagination = const StoryViewersPagination(),
  });

  factory StoryViewersResponse.fromJson(Map<String, dynamic> json) {
    return StoryViewersResponse(
      storyId: json['story_id'] as String?,
      mediaUrl: json['media_url'] as String?,
      mediaType: json['media_type'] as String?,
      createdAt: json['created_at'] as String?,
      expiresAt: json['expires_at'] as String?,
      totalViewCount: json['total_view_count'] as int? ?? 0,
      viewers:
          (json['viewers'] as List<dynamic>?)?.map((e) {
            final viewerData = e as Map<String, dynamic>;
            final viewer = viewerData['viewer'] as Map<String, dynamic>? ?? {};
            return MyStoryViewersModel(
              id: viewer['id'] as String?,
              username: viewer['username'] as String?,
              fullName: viewer['full_name'] as String?,
              profilePhotoUrl: viewer['profile_photo_url'] as String?,
              viewedAt: viewerData['viewed_at'] != null
                  ? DateTime.tryParse(viewerData['viewed_at'] as String)
                  : null,
            );
          }).toList() ??
          [],
      pagination: json['pagination'] != null
          ? StoryViewersPagination.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : const StoryViewersPagination(),
    );
  }
}

class StoryViewersPagination {
  final int page;
  final int limit;
  final int totalCount;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const StoryViewersPagination({
    this.page = 1,
    this.limit = 20,
    this.totalCount = 0,
    this.totalPages = 0,
    this.hasNext = false,
    this.hasPrevious = false,
  });

  factory StoryViewersPagination.fromJson(Map<String, dynamic> json) {
    return StoryViewersPagination(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalCount: json['total_count'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }
}
