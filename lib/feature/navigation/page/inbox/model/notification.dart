import 'package:rightflair/core/constants/enums/notification_category.dart';
import 'package:rightflair/core/constants/enums/notification_type.dart';

import '../../../../../core/base/model/base.dart';
import 'notification_sender.dart';

class NotificationModel extends BaseModel<NotificationModel> {
  String? id;
  NotificationCategory? category;
  NotificationType? type;
  String? title;
  String? content;
  String? postId;
  String? commentId;
  NotificationSenderModel? sender;
  bool? isRead;
  DateTime? createdAt;

  NotificationModel({
    this.id,
    this.category,
    this.type,
    this.title,
    this.content,
    this.postId,
    this.commentId,
    this.sender,
    this.isRead,
    this.createdAt,
  });

  @override
  NotificationModel copyWith({
    String? id,
    NotificationCategory? category,
    NotificationType? type,
    String? title,
    String? content,
    String? postId,
    String? commentId,
    NotificationSenderModel? sender,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      category: category ?? this.category,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      sender: sender ?? this.sender,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  NotificationModel fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String?,
      category: NotificationCategory.find(
        value: json['category'] as String? ?? '',
      ),
      type: NotificationType.find(value: json['type'] as String? ?? ''),
      title: json['title'] as String?,
      content: json['content'] as String?,
      postId: json['post_id'] as String?,
      commentId: json['comment_id'] as String?,
      sender: json['sender'] != null
          ? NotificationSenderModel().fromJson(json['sender'])
          : null,
      isRead: json['is_read'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category?.value,
      'type': type?.value,
      'title': title,
      'content': content,
      'post_id': postId,
      'comment_id': commentId,
      'sender': sender?.toJson(),
      'is_read': isRead,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
