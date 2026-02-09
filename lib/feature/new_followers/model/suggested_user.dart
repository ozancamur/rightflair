import '../../../core/base/model/base.dart';
import '../../navigation/page/inbox/model/notification_sender.dart';
import '../../navigation/page/inbox/model/pagination_notification.dart';

class SuggestedUserModel extends BaseModel<SuggestedUserModel> {
  List<NotificationSenderModel>? suggestedUsers;
  PaginationNotificationModel? pagination;

  SuggestedUserModel({this.suggestedUsers, this.pagination});

  @override
  SuggestedUserModel copyWith({
    List<NotificationSenderModel>? suggestedUsers,
    PaginationNotificationModel? pagination,
  }) {
    return SuggestedUserModel(
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  SuggestedUserModel fromJson(Map<String, dynamic> json) {
    return SuggestedUserModel(
      suggestedUsers: (json['suggested_users'] as List<dynamic>?)
          ?.map(
            (e) =>
                NotificationSenderModel().fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationNotificationModel().fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'suggested_users': suggestedUsers?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}
