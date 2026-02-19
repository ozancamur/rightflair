import '../../../core/base/model/base.dart';

class SendMessageRequestModel extends BaseModel<SendMessageRequestModel> {
  String? conversationId;
  String? recipientId;
  String? messageType;
  String? content;
  String? imageUrl;
  String? referencedUserId;
  String? referencedPostId;

  SendMessageRequestModel({
    this.conversationId,
    this.recipientId,
    this.messageType,
    this.content,
    this.imageUrl,
    this.referencedUserId,
    this.referencedPostId,
  });

  @override
  SendMessageRequestModel copyWith({
    String? conversationId,
    String? recipientId,
    String? messageType,
    String? content,
    String? imageUrl,
    String? referencedUserId,
    String? referencedPostId,
  }) {
    return SendMessageRequestModel(
      conversationId: conversationId ?? this.conversationId,
      recipientId: recipientId ?? this.recipientId,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      referencedUserId: referencedUserId ?? this.referencedUserId,
      referencedPostId: referencedPostId ?? this.referencedPostId,
    );
  }

  @override
  SendMessageRequestModel fromJson(Map<String, dynamic> json) {
    return SendMessageRequestModel(
      conversationId: json['conversation_id'] as String?,
      recipientId: json['recipient_id'] as String?,
      messageType: json['message_type'] as String?,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      referencedUserId: json['referenced_user_id'] as String?,
      referencedPostId: json['referenced_post_id'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (conversationId != null) {
      data['conversation_id'] = conversationId;
    }
    if (recipientId != null) {
      data['recipient_id'] = recipientId;
    }
    if (messageType != null) {
      data['message_type'] = messageType;
    }
    if (content != null && content!.isNotEmpty) {
      data['content'] = content;
    }
    if (imageUrl != null) {
      data['image_url'] = imageUrl;
    }
    if (referencedUserId != null) {
      data['referenced_user_id'] = referencedUserId;
    }
    if (referencedPostId != null) {
      data['referenced_post_id'] = referencedPostId;
    }

    return data;
  }
}
