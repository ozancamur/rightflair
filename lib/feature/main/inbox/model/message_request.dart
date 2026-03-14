import '../../../../core/base/model/base.dart';
import 'participant.dart';

class MessageRequestModel extends BaseModel<MessageRequestModel> {
  String? conversationId;
  String? requestStatus;
  DateTime? requestedAt;
  ParticipantModel? sender;
  String? lastMessagePreview;
  DateTime? lastMessageAt;

  MessageRequestModel({
    this.conversationId,
    this.requestStatus,
    this.requestedAt,
    this.sender,
    this.lastMessagePreview,
    this.lastMessageAt,
  });

  @override
  MessageRequestModel copyWith({
    String? conversationId,
    String? requestStatus,
    DateTime? requestedAt,
    ParticipantModel? sender,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
  }) {
    return MessageRequestModel(
      conversationId: conversationId ?? this.conversationId,
      requestStatus: requestStatus ?? this.requestStatus,
      requestedAt: requestedAt ?? this.requestedAt,
      sender: sender ?? this.sender,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  @override
  MessageRequestModel fromJson(Map<String, dynamic> json) {
    return MessageRequestModel(
      conversationId: json['conversation_id'] as String?,
      requestStatus: json['request_status'] as String?,
      requestedAt: json['requested_at'] != null
          ? DateTime.parse(json['requested_at'] as String)
          : null,
      sender: json['sender'] != null
          ? ParticipantModel().fromJson(json['sender'])
          : null,
      lastMessagePreview: json['last_message_preview'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'request_status': requestStatus,
      'requested_at': requestedAt?.toIso8601String(),
      if (sender != null) 'sender': sender!.toJson(),
      'last_message_preview': lastMessagePreview,
      'last_message_at': lastMessageAt?.toIso8601String(),
    };
  }
}
