import '../../../../core/base/model/base.dart';

class StreamConversationLastMessageModel
    extends BaseModel<StreamConversationLastMessageModel> {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastMessageAt;
  String? lastMessagePreview;
  String? lastMessageSenderId;

  StreamConversationLastMessageModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.lastMessageAt,
    this.lastMessagePreview,
    this.lastMessageSenderId,
  });

  @override
  StreamConversationLastMessageModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastMessageAt,
    String? lastMessagePreview,
    String? lastMessageSenderId,
  }) {
    return StreamConversationLastMessageModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
    );
  }

  @override
  StreamConversationLastMessageModel fromJson(Map<String, dynamic> json) {
    return StreamConversationLastMessageModel(
      id: json['id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessagePreview: json['last_message_preview'] as String?,
      lastMessageSenderId: json['last_message_sender_id'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message_preview': lastMessagePreview,
      'last_message_sender_id': lastMessageSenderId,
    };
  }
}
