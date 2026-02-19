import '../../../core/base/model/base.dart';

class SearchUserModel extends BaseModel<SearchUserModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;

  SearchUserModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
  });

  @override
  SearchUserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
  }) {
    return SearchUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }

  @override
  SearchUserModel fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}
