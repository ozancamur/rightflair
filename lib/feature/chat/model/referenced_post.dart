import '../../../core/base/model/base.dart';
import 'message_sender.dart';

class ReferencedPostModel extends BaseModel<ReferencedPostModel> {
  String? id;
  String? postImageUrl;
  String? description;
  MessageSenderModel? user;

  ReferencedPostModel({
    this.id,
    this.postImageUrl,
    this.description,
    this.user,
  });

  @override
  ReferencedPostModel copyWith({
    String? id,
    String? postImageUrl,
    String? description,
    MessageSenderModel? user,
  }) {
    return ReferencedPostModel(
      id: id ?? this.id,
      postImageUrl: postImageUrl ?? this.postImageUrl,
      description: description ?? this.description,
      user: user ?? this.user,
    );
  }

  @override
  ReferencedPostModel fromJson(Map<String, dynamic> json) {
    return ReferencedPostModel(
      id: json['id'] as String?,
      postImageUrl: json['post_image_url'] as String?,
      description: json['description'] as String?,
      user: json['user'] != null
          ? MessageSenderModel().fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_image_url': postImageUrl,
      'description': description,
      'user': user?.toJson(),
    };
  }
}
