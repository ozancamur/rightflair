import '../../../core/base/model/base.dart';

class ProfileModel extends BaseModel<ProfileModel> {
  String? uid;
  String? username;
  String? image;

  ProfileModel({this.uid, this.username, this.image});

  @override
  copyWith({String? uid, String? username, String? image}) {
    return ProfileModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      image: image ?? this.image,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'] as String?,
      username: json['username'] as String?,
      image: json['image'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'username': username, 'image': image};
  }
}
