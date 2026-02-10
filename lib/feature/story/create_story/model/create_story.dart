import '../../../../core/base/model/base.dart';

class CreateStoryModel extends BaseModel<CreateStoryModel> {
  String? mediaUrl;
  String? mediaType;
  int? duration;

  CreateStoryModel({this.mediaUrl, this.mediaType, this.duration});

  @override
  CreateStoryModel copyWith({
    String? mediaUrl,
    String? mediaType,
    int? duration,
  }) {
    return CreateStoryModel(
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      duration: duration ?? this.duration,
    );
  }

  @override
  CreateStoryModel fromJson(Map<String, dynamic> json) {
    return CreateStoryModel(
      mediaUrl: json['media_url'] as String?,
      mediaType: json['media_type'] as String?,
      duration: json['duration'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {'media_url': mediaUrl};

    if (mediaType != null) {
      json['media_type'] = mediaType;
    }

    if (duration != null) {
      json['duration'] = duration;
    }

    return json;
  }
}
