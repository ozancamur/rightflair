import 'package:rightflair/core/constants/enums/message_send_status.dart';
import 'package:rightflair/feature/chat/model/message_sender.dart';

import '../../../core/base/model/base.dart';
import 'chat_message.dart';

class NewMessageModel extends BaseModel<NewMessageModel> {
  String? id;
  String? messageType;
  String? content;
  String? imageUrl;
  String? senderId;
  String? referencedUserId;
  String? referencedPostId;
  DateTime? createdAt;
  String? conversationId;

  NewMessageModel({
    this.id,
    this.messageType,
    this.content,
    this.imageUrl,
    this.senderId,
    this.referencedUserId,
    this.referencedPostId,
    this.createdAt,
    this.conversationId,
  });

  @override
  NewMessageModel copyWith({
    String? id,
    String? messageType,
    String? content,
    String? imageUrl,
    String? senderId,
    String? referencedUserId,
    String? referencedPostId,
    DateTime? createdAt,
    String? conversationId,
  }) {
    return NewMessageModel(
      id: id ?? this.id,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      senderId: senderId ?? this.senderId,
      referencedUserId: referencedUserId ?? this.referencedUserId,
      referencedPostId: referencedPostId ?? this.referencedPostId,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
    );
  }

  @override
  NewMessageModel fromJson(Map<String, dynamic> json) {
    return NewMessageModel(
      id: json['id'] as String?,
      messageType: json['message_type'] as String?,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      senderId: json['sender_id'] as String?,
      referencedUserId: json['referenced_user_id'] as String?,
      referencedPostId: json['referenced_post_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      conversationId: json['conversation_id'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message_type': messageType,
      'content': content,
      'image_url': imageUrl,
      'sender_id': senderId,
      'referenced_user_id': referencedUserId,
      'referenced_post_id': referencedPostId,
      'created_at': createdAt?.toIso8601String(),
      'conversation_id': conversationId,
    };
  }

  ChatMessageModel convertToChatMessageModel({
    required MessageSenderModel sender,
  }) {
    return ChatMessageModel(
      id: id,
      messageType: messageType ?? 'text',
      content: content,
      imageUrl: imageUrl,
      sender: sender,
      createdAt: createdAt,
      sendStatus: MessageSendStatus.sent,
    );
  }
}
