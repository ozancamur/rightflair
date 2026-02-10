import '../../../../core/base/model/base.dart';

class LastMessageModel extends BaseModel<LastMessageModel> {
  String? content;
  String? imageUrl;
  String? senderId;
  DateTime? sentAt;
  bool? isOwnMessage;
  bool? isRead;

  LastMessageModel({
    this.content,
    this.imageUrl,
    this.senderId,
    this.sentAt,
    this.isOwnMessage,
    this.isRead,
  });

  @override
  LastMessageModel copyWith({
    String? content,
    String? imageUrl,
    String? senderId,
    DateTime? sentAt,
    bool? isOwnMessage,
    bool? isRead,
  }) {
    return LastMessageModel(
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      senderId: senderId ?? this.senderId,
      sentAt: sentAt ?? this.sentAt,
      isOwnMessage: isOwnMessage ?? this.isOwnMessage,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  LastMessageModel fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      senderId: json['sender_id'] as String?,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : null,
      isOwnMessage: json['is_own_message'] as bool?,
      isRead: json['is_read'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'image_url': imageUrl,
      'sender_id': senderId,
      'sent_at': sentAt?.toIso8601String(),
      'is_own_message': isOwnMessage,
      'is_read': isRead,
    };
  }
}
