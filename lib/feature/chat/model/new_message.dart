import 'package:rightflair/core/constants/enums/message_send_status.dart';
import 'package:rightflair/feature/chat/model/message_sender.dart';

import '../../../core/base/model/base.dart';
import 'chat_message.dart';

class NewMessageModel extends BaseModel<NewMessageModel> {
  String? id;
  String? content;
  String? imageUrl;
  String? senderId;
  DateTime? createdAt;
  String? conversationId;

  NewMessageModel({
    this.id,
    this.content,
    this.imageUrl,
    this.senderId,
    this.createdAt,
    this.conversationId,
  });

  @override
  NewMessageModel copyWith({
    String? id,
    String? content,
    String? imageUrl,
    String? senderId,
    DateTime? createdAt,
    String? conversationId,
  }) {
    return NewMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      senderId: senderId ?? this.senderId,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
    );
  }

  @override
  NewMessageModel fromJson(Map<String, dynamic> json) {
    return NewMessageModel(
      id: json['id'] as String?,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      senderId: json['sender_id'] as String?,
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
      'content': content,
      'image_url': imageUrl,
      'sender_id': senderId,
      'created_at': createdAt?.toIso8601String(),
      'conversation_id': conversationId,
    };
  }

  ChatMessageModel convertToChatMessageModel({required MessageSenderModel sender}) {
    return ChatMessageModel(
      id: id,
      content: content,
      imageUrl: imageUrl,
      sender: sender,
      createdAt: createdAt,
      sendStatus: MessageSendStatus.sent,
    );
  }
}
