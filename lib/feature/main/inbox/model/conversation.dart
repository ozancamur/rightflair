import '../../../../core/base/model/base.dart';
import 'last_message.dart';
import 'participant.dart';

class ConversationModel extends BaseModel<ConversationModel> {
  String? id;
  ParticipantModel? participant;
  LastMessageModel? lastMessage;

  ConversationModel({this.id, this.participant, this.lastMessage});
  @override
  ConversationModel copyWith({
    String? id,
    ParticipantModel? participant,
    LastMessageModel? lastMessage,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      participant: participant ?? this.participant,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  ConversationModel fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String?,
      participant: json['participant'] != null
          ? ParticipantModel().fromJson(json['participant'])
          : null,
      lastMessage: json['last_message'] != null
          ? LastMessageModel().fromJson(json['last_message'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (participant != null) {
      data['participant'] = participant!.toJson();
    }
    if (lastMessage != null) {
      data['last_message'] = lastMessage!.toJson();
    }
    return data;
  }
}
