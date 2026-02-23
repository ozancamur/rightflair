import '../../../core/base/model/base.dart';

class SuggestedUserModel extends BaseModel<SuggestedUserModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;
  String? mutualInfo;
  List<String>? previewPhotos;

  SuggestedUserModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
    this.mutualInfo,
    this.previewPhotos,
  });

  @override
  SuggestedUserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
    String? mutualInfo,
    List<String>? previewPhotos,
  }) {
    return SuggestedUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      mutualInfo: mutualInfo ?? this.mutualInfo,
      previewPhotos: previewPhotos ?? this.previewPhotos,
    );
  }

  @override
  SuggestedUserModel fromJson(Map<String, dynamic> json) {
    return SuggestedUserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      mutualInfo: json['mutual_info'] as String?,
      previewPhotos: (json['preview_photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
      'mutual_info': mutualInfo,
      'preview_photos': previewPhotos,
    };
  }
}
