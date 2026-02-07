import '../../../../../core/base/model/base.dart';

class StoryModel extends BaseModel<StoryModel> {
  String? id;
  String? mediaUrl;
  String? mediaType;
  int? duration;
  int? viewCount;
  DateTime? createdAt;
  DateTime? expiresAt;
  bool? isViewed;

  StoryModel({
    this.id,
    this.mediaUrl,
    this.mediaType,
    this.duration,
    this.viewCount,
    this.createdAt,
    this.expiresAt,
    this.isViewed,
  });

  @override
  StoryModel copyWith({
    String? id,
    String? mediaUrl,
    String? mediaType,
    int? duration,
    int? viewCount,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isViewed,
  }) {
    return StoryModel(
      id: id ?? this.id,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      duration: duration ?? this.duration,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }

  @override
  StoryModel fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String?,
      mediaUrl: json['media_url'] as String?,
      mediaType: json['media_type'] as String?,
      duration: json['duration'] as int?,
      viewCount: json['view_count'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      isViewed: json['is_viewed'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'duration': duration,
      'view_count': viewCount,
      'created_at': createdAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'is_viewed': isViewed,
    };
  }
}
