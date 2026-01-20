import '../../../core/base/model/base.dart';

class UserModel extends BaseModel<UserModel> {
  String? id;
  String? email;
  String? username;
  String? fullName;
  String? bio;
  String? profilePhotoUrl;
  String? role;
  String? status;
  int? followersCount;
  int? followingCount;
  DateTime? createdAt;
  DateTime? lastActive;
  String? fcm;

  UserModel({
    this.id,
    this.email,
    this.username,
    this.fullName,
    this.bio,
    this.profilePhotoUrl,
    this.role,
    this.status,
    this.followersCount,
    this.followingCount,
    this.createdAt,
    this.lastActive,
    this.fcm,
  });

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? bio,
    String? profilePhotoUrl,
    String? role,
    String? status,
    int? followersCount,
    int? followingCount,
    DateTime? createdAt,
    DateTime? lastActive,
    String? fcm,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      fcm: fcm ?? this.fcm,
    );
  }

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      bio: json['bio'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      followersCount: json['followers_count'] as int?,
      followingCount: json['following_count'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'] as String)
          : null,
      fcm: json['fcm'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'bio': bio,
      'profile_photo_url': profilePhotoUrl,
      'role': role,
      'status': status,
      'followers_count': followersCount,
      'following_count': followingCount,
      'created_at': createdAt?.toIso8601String(),
      'last_active': lastActive?.toIso8601String(),
      'fcm': fcm,
    };
  }
}
