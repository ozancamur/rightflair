import '../../../core/base/model/base.dart';
import '../../../core/constants/enums/message_send_status.dart';
import 'message_sender.dart';
import 'referenced_post.dart';

class ChatMessageModel extends BaseModel<ChatMessageModel> {
  String? id;
  String? messageType;
  String? content;
  String? imageUrl;
  MessageSenderModel? referencedUser;
  ReferencedPostModel? referencedPost;
  MessageSenderModel? sender;
  bool? isOwnMessage;
  bool? isRead;
  DateTime? createdAt;
  MessageSendStatus? sendStatus;

  ChatMessageModel({
    this.id,
    this.messageType,
    this.content,
    this.imageUrl,
    this.referencedUser,
    this.referencedPost,
    this.sender,
    this.isOwnMessage,
    this.isRead,
    this.createdAt,
    this.sendStatus,
  });

  @override
  ChatMessageModel copyWith({
    String? id,
    String? messageType,
    String? content,
    String? imageUrl,
    MessageSenderModel? referencedUser,
    ReferencedPostModel? referencedPost,
    MessageSenderModel? sender,
    bool? isOwnMessage,
    bool? isRead,
    DateTime? createdAt,
    MessageSendStatus? sendStatus,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      referencedUser: referencedUser ?? this.referencedUser,
      referencedPost: referencedPost ?? this.referencedPost,
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
      messageType: json['message_type'] as String? ?? 'text',
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      referencedUser: json['referenced_user'] != null
          ? MessageSenderModel().fromJson(
              json['referenced_user'] as Map<String, dynamic>,
            )
          : null,
      referencedPost: json['referenced_post'] != null
          ? ReferencedPostModel().fromJson(
              json['referenced_post'] as Map<String, dynamic>,
            )
          : null,
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
      'message_type': messageType,
      'content': content,
      'image_url': imageUrl,
      'referenced_user': referencedUser?.toJson(),
      'referenced_post': referencedPost?.toJson(),
      'sender': sender?.toJson(),
      'is_own_message': isOwnMessage,
      'is_read': isRead,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
