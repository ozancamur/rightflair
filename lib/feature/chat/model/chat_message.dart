import '../../../core/base/model/base.dart';
import 'message_send_status.dart';
import 'message_sender.dart';

class ChatMessageModel extends BaseModel<ChatMessageModel> {
  String? id;
  String? content;
  String? imageUrl;
  MessageSenderModel? sender;
  bool? isOwnMessage;
  bool? isRead;
  DateTime? createdAt;
  MessageSendStatus? sendStatus;

  ChatMessageModel({
    this.id,
    this.content,
    this.imageUrl,
    this.sender,
    this.isOwnMessage,
    this.isRead,
    this.createdAt,
    this.sendStatus,
  });

  @override
  ChatMessageModel copyWith({
    String? id,
    String? content,
    String? imageUrl,
    MessageSenderModel? sender,
    bool? isOwnMessage,
    bool? isRead,
    DateTime? createdAt,
    MessageSendStatus? sendStatus,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      sender: sender ?? this.sender,
      isOwnMessage: isOwnMessage ?? this.isOwnMessage,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      sendStatus: sendStatus ?? this.sendStatus,
    );
  }

  @override
  ChatMessageModel fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String?,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      sender: json['sender'] != null
          ? MessageSenderModel().fromJson(json['sender'])
          : null,
      isOwnMessage: json['is_own_message'] as bool?,
      isRead: json['is_read'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'image_url': imageUrl,
      'sender': sender?.toJson(),
      'is_own_message': isOwnMessage,
      'is_read': isRead,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
