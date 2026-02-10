import '../../../../core/base/model/base.dart';

// ignore: must_be_immutable
class MyStoryViewersModel extends BaseModel<MyStoryViewersModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;
  DateTime? viewedAt;

  MyStoryViewersModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
    this.viewedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyStoryViewersModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          fullName == other.fullName &&
          profilePhotoUrl == other.profilePhotoUrl &&
          viewedAt == other.viewedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      fullName.hashCode ^
      profilePhotoUrl.hashCode ^
      viewedAt.hashCode;

  @override
  MyStoryViewersModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
    DateTime? viewedAt,
  }) {
    return MyStoryViewersModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }

  @override
  MyStoryViewersModel fromJson(Map<String, dynamic> json) {
    return MyStoryViewersModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      viewedAt: json['viewed_at'] != null
          ? DateTime.parse(json['viewed_at'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
      'viewed_at': viewedAt?.toIso8601String(),
    };
  }
}
