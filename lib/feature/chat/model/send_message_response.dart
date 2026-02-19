import '../../../core/base/model/base.dart';
import 'chat_message.dart';
import 'message_sender.dart';
import 'referenced_post.dart';

class SendMessageResponseModel extends BaseModel<SendMessageResponseModel> {
  String? messageId;
  String? conversationId;
  String? messageType;
  String? content;
  String? imageUrl;
  MessageSenderModel? referencedUser;
  ReferencedPostModel? referencedPost;
  ChatMessageModel? message;
  bool? isNewConversation;

  SendMessageResponseModel({
    this.messageId,
    this.conversationId,
    this.messageType,
    this.content,
    this.imageUrl,
    this.referencedUser,
    this.referencedPost,
    this.message,
    this.isNewConversation,
  });

  @override
  SendMessageResponseModel copyWith({
    String? messageId,
    String? conversationId,
    String? messageType,
    String? content,
    String? imageUrl,
    MessageSenderModel? referencedUser,
    ReferencedPostModel? referencedPost,
    ChatMessageModel? message,
    bool? isNewConversation,
  }) {
    return SendMessageResponseModel(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      referencedUser: referencedUser ?? this.referencedUser,
      referencedPost: referencedPost ?? this.referencedPost,
      message: message ?? this.message,
      isNewConversation: isNewConversation ?? this.isNewConversation,
    );
  }

  @override
  SendMessageResponseModel fromJson(Map<String, dynamic> json) {
    ChatMessageModel? messageModel;

    MessageSenderModel? refUser;
    if (json['referenced_user'] != null) {
      refUser = MessageSenderModel().fromJson(
        json['referenced_user'] as Map<String, dynamic>,
      );
    }

    ReferencedPostModel? refPost;
    if (json['referenced_post'] != null) {
      refPost = ReferencedPostModel().fromJson(
        json['referenced_post'] as Map<String, dynamic>,
      );
    }

    if (json['message_id'] != null) {
      messageModel = ChatMessageModel(
        id: json['message_id'] as String?,
        messageType: json['message_type'] as String? ?? 'text',
        content: json['content'] as String?,
        imageUrl: json['image_url'] as String?,
        referencedUser: refUser,
        referencedPost: refPost,
        sender: json['sender'] != null
            ? MessageSenderModel().fromJson(
                json['sender'] as Map<String, dynamic>,
              )
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        isOwnMessage: true,
        isRead: false,
      );
    }

    return SendMessageResponseModel(
      messageId: json['message_id'] as String?,
      conversationId: json['conversation_id'] as String?,
      messageType: json['message_type'] as String? ?? 'text',
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      referencedUser: refUser,
      referencedPost: refPost,
      message: messageModel,
      isNewConversation: json['is_new_conversation'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'conversation_id': conversationId,
      'message_type': messageType,
      'content': content,
      'image_url': imageUrl,
      'referenced_user': referencedUser?.toJson(),
      'referenced_post': referencedPost?.toJson(),
      'is_new_conversation': isNewConversation,
    };
  }
}
