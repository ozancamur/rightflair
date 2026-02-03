import '../../../core/base/model/base.dart';
import 'chat_message.dart';
import 'message_sender.dart';

class SendMessageResponseModel extends BaseModel<SendMessageResponseModel> {
  String? messageId;
  String? conversationId;
  String? content;
  String? imageUrl;
  ChatMessageModel? message;
  bool? isNewConversation;

  SendMessageResponseModel({
    this.messageId,
    this.conversationId,
    this.content,
    this.imageUrl,
    this.message,
    this.isNewConversation,
  });

  @override
  SendMessageResponseModel copyWith({
    String? messageId,
    String? conversationId,
    String? content,
    String? imageUrl,
    ChatMessageModel? message,
    bool? isNewConversation,
  }) {
    return SendMessageResponseModel(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      message: message ?? this.message,
      isNewConversation: isNewConversation ?? this.isNewConversation,
    );
  }

  @override
  SendMessageResponseModel fromJson(Map<String, dynamic> json) {
    ChatMessageModel? messageModel;

    // Create a message model from the response data
    if (json['message_id'] != null) {
      messageModel = ChatMessageModel(
        id: json['message_id'] as String?,
        content: json['content'] as String?,
        imageUrl: json['image_url'] as String?,
        sender: json['sender'] != null
            ? MessageSenderModel().fromJson(
                json['sender'] as Map<String, dynamic>,
              )
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        isOwnMessage: true, // Message just sent by current user
        isRead: false,
      );
    }

    return SendMessageResponseModel(
      messageId: json['message_id'] as String?,
      conversationId: json['conversation_id'] as String?,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      message: messageModel,
      isNewConversation: json['is_new_conversation'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'conversation_id': conversationId,
      'content': content,
      'image_url': imageUrl,
      'is_new_conversation': isNewConversation,
    };
  }
}
