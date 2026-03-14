import '../../../../core/base/model/base.dart';
import 'message_request.dart';
import 'pagination_notification.dart';

class ResponseMessageRequestsModel
    extends BaseModel<ResponseMessageRequestsModel> {
  List<MessageRequestModel>? requests;
  PaginationNotificationModel? pagination;

  ResponseMessageRequestsModel({this.requests, this.pagination});

  @override
  ResponseMessageRequestsModel copyWith({
    List<MessageRequestModel>? requests,
    PaginationNotificationModel? pagination,
  }) {
    return ResponseMessageRequestsModel(
      requests: requests ?? this.requests,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  ResponseMessageRequestsModel fromJson(Map<String, dynamic> json) {
    return ResponseMessageRequestsModel(
      requests: json['requests'] != null
          ? (json['requests'] as List)
                .map((e) => MessageRequestModel().fromJson(e))
                .toList()
          : null,
      pagination: json['pagination'] != null
          ? PaginationNotificationModel().fromJson(json['pagination'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (requests != null)
        'requests': requests!.map((v) => v.toJson()).toList(),
      if (pagination != null) 'pagination': pagination!.toJson(),
    };
  }
}
