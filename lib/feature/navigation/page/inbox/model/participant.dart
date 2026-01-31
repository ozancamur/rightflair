import '../../../../../core/base/model/base.dart';

class ParticipantModel extends BaseModel<ParticipantModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;
  String? status;

  ParticipantModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
    this.status,
  });

  @override
  ParticipantModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
    String? status,
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      status: status ?? this.status,
    );
  }

  @override
  ParticipantModel fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      status: json['status'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
      'status': status,
    };
  }
}
