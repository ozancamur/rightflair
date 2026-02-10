import '../../../../core/base/model/base.dart';
import 'my_story_viewers.dart';

// ignore: must_be_immutable
class MyStoryItemModel extends BaseModel<MyStoryItemModel> {
  String? id;
  String? mediaUrl;
  String? mediaType;
  int? duration;
  int? viewCount;
  DateTime? createdAt;
  DateTime? expiresAt;
  bool? isExpired;
  int? timeRemainingSeconds;
  List<MyStoryViewersModel>? viewers;
  int? totalViewers;

  MyStoryItemModel({
    this.id,
    this.mediaUrl,
    this.mediaType,
    this.duration,
    this.viewCount,
    this.createdAt,
    this.expiresAt,
    this.isExpired,
    this.timeRemainingSeconds,
    this.viewers,
    this.totalViewers,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyStoryItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          mediaUrl == other.mediaUrl &&
          mediaType == other.mediaType &&
          duration == other.duration &&
          viewCount == other.viewCount &&
          createdAt == other.createdAt &&
          expiresAt == other.expiresAt &&
          isExpired == other.isExpired &&
          timeRemainingSeconds == other.timeRemainingSeconds;

  @override
  int get hashCode =>
      id.hashCode ^
      mediaUrl.hashCode ^
      mediaType.hashCode ^
      duration.hashCode ^
      viewCount.hashCode;

  @override
  MyStoryItemModel copyWith({
    String? id,
    String? mediaUrl,
    String? mediaType,
    int? duration,
    int? viewCount,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isExpired,
    int? timeRemainingSeconds,
    List<MyStoryViewersModel>? viewers,
    int? totalViewers,
  }) {
    return MyStoryItemModel(
      id: id ?? this.id,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      duration: duration ?? this.duration,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isExpired: isExpired ?? this.isExpired,
      timeRemainingSeconds: timeRemainingSeconds ?? this.timeRemainingSeconds,
      viewers: viewers ?? this.viewers,
      totalViewers: totalViewers ?? this.totalViewers,
    );
  }

  @override
  MyStoryItemModel fromJson(Map<String, dynamic> json) {
    return MyStoryItemModel(
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
      isExpired: json['is_expired'] as bool?,
      timeRemainingSeconds: json['time_remaining_seconds'] as int?,
      viewers: (json['viewers'] as List<dynamic>?)
          ?.map(
            (e) => MyStoryViewersModel().fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      totalViewers: json['total_viewers'] as int?,
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
      'is_expired': isExpired,
      'time_remaining_seconds': timeRemainingSeconds,
      'viewers': viewers?.map((e) => e.toJson()).toList(),
      'total_viewers': totalViewers,
    };
  }
}
