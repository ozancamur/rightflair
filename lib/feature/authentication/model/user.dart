import 'package:rightflair/core/base/base_modeld.dart';

class ProfileModel extends BaseModel<ProfileModel> {
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


  ProfileModel({
    this.uid,
    this.token,
    this.email,
    this.fullName,
    this.username,
  });

  @override
  ProfileModel fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'] as String?,
      token: json['token'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      username: json['username'] as String?,
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
    };
  }

  @override
  ProfileModel copyWith({
    String? uid,
    String? token,
    String? email,
    String? fullName,
    String? username,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      token: token ?? this.token,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
    );
  }
}
