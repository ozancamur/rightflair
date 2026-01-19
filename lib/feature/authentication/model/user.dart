import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/base/model/base.dart';

class UserModel extends BaseModel<UserModel> {
  String? uid;
  String? token;
  String? email;
  String? fullName;
  String? username;
  String? bio;
  String? image;
  List<String>? tags;
  List<String>? followers;
  List<String>? followings;
  DateTime? createdAt;
  DateTime? lastActiveAt;
  List<String>? posts;
  List<String>? saves;
  List<String>? drafts;

  UserModel({
    this.uid,
    this.token,
    this.email,
    this.fullName,
    this.username,
    this.bio,
    this.image,
    this.tags,
    this.followers,
    this.followings,
    this.createdAt,
    this.lastActiveAt,
    this.posts,
    this.saves,
    this.drafts,
  });

  @override
  copyWith({
    String? uid,
    String? token,
    String? email,
    String? fullName,
    String? username,
    String? bio,
    String? image,
    List<String>? tags,
    List<String>? followers,
    List<String>? followings,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    List<String>? posts,
    List<String>? saves,
    List<String>? drafts,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      token: token ?? this.token,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      tags: tags ?? this.tags,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      posts: posts ?? this.posts,
      saves: saves ?? this.saves,
      drafts: drafts ?? this.drafts,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      token: json['token'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      username: json['username'] as String?,
      bio: json['bio'] as String?,
      image: json['image'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      followings: (json['followings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      lastActiveAt: json['lastActiveAt'] != null
          ? (json['lastActiveAt'] as Timestamp).toDate()
          : null,
      posts: (json['posts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      saves: (json['saves'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      drafts: (json['drafts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'token': token,
      'email': email,
      'fullName': fullName,
      'username': username,
      'bio': bio,
      'image': image,
      'tags': tags,
      'followers': followers,
      'followings': followings,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastActiveAt': lastActiveAt != null
          ? Timestamp.fromDate(lastActiveAt!)
          : null,
      'posts': posts,
      'saves': saves,
      'drafts': drafts,
    };
  }
}
