import 'package:rightflair/feature/navigation/page/inbox/model/pagination_notification.dart';

import '../../../../../core/base/model/base.dart';
import 'notification.dart';

class ResponseNotificationsModel extends BaseModel<ResponseNotificationsModel> {
  List<NotificationModel>? notifications;
  int? unreadCount;
  PaginationNotificationModel? pagination;

  ResponseNotificationsModel({
    this.notifications,
    this.unreadCount,
    this.pagination,
  });

  @override
  ResponseNotificationsModel copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    PaginationNotificationModel? pagination,
  }) {
    return ResponseNotificationsModel(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  ResponseNotificationsModel fromJson(Map<String, dynamic> json) {
    return ResponseNotificationsModel(
      notifications: (json['notifications'] as List?)
          ?.map((e) => NotificationModel().fromJson(e))
          .toList(),
      unreadCount: json['unread_count'] as int?,
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
      'notifications': notifications?.map((e) => e.toJson()).toList(),
      'unread_count': unreadCount,
      'pagination': pagination?.toJson(),
    };
  }
}
