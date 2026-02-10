import '../../../../core/base/model/base.dart';
import '../../profile/model/pagination.dart';
import 'conversation.dart';


class ConversationsModel extends BaseModel<ConversationsModel> {
  
  List<ConversationModel>? conversations;
  PaginationModel? pagination;
  
  ConversationsModel({this.conversations, this.pagination});

  @override
  ConversationsModel copyWith(
    {
    List<ConversationModel>? conversations,
    PaginationModel? pagination,
    }
  ) {
    return ConversationsModel(
      conversations: conversations ?? this.conversations,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  ConversationsModel fromJson(Map<String, dynamic> json) {
    return ConversationsModel(
      conversations: json['conversations'] != null
          ? (json['conversations'] as List)
              .map((e) => ConversationModel().fromJson(e))
              .toList()
          : null,
      pagination: json['pagination'] != null
          ? PaginationModel().fromJson(json['pagination'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversations != null) {
      data['conversations'] =
          conversations!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }

}