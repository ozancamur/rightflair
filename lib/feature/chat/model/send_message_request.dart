import '../../../core/base/model/base.dart';

class SendMessageRequestModel extends BaseModel<SendMessageRequestModel> {
  String? conversationId;
  String? recipientId;
  String? content;
  String? imageUrl;

  SendMessageRequestModel({
    this.conversationId,
    this.recipientId,
    this.content,
    this.imageUrl,
  });

  @override
  SendMessageRequestModel copyWith({
    String? conversationId,
    String? recipientId,
    String? content,
    String? imageUrl,
  }) {
    return SendMessageRequestModel(
      conversationId: conversationId ?? this.conversationId,
      recipientId: recipientId ?? this.recipientId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  SendMessageRequestModel fromJson(Map<String, dynamic> json) {
    return SendMessageRequestModel(
      conversationId: json['conversation_id'] as String?,
      recipientId: json['recipient_id'] as String?,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
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
    if (content != null && content!.isNotEmpty) {
      data['content'] = content;
    }
    if (imageUrl != null) {
      data['image_url'] = imageUrl;
    }

    return data;
  }
}
