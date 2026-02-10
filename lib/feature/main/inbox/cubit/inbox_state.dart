import 'package:equatable/equatable.dart';
import 'package:rightflair/feature/main/inbox/model/pagination_notification.dart';

import '../../profile/model/pagination.dart';
import '../model/conversation.dart';
import '../model/notification.dart';

class InboxState extends Equatable {
  final bool isConversationsLoading;
  final List<ConversationModel>? conversations;
  final PaginationModel? conversationsPagination;

  final bool isNotificationsLoading;
  final List<NotificationModel>? activityNotifications;
  final PaginationNotificationModel? activityNotificationsPagination;

  final List<NotificationModel>? systemNotifications;

  const InboxState({
    this.isConversationsLoading = false,
    this.conversations,
    this.conversationsPagination,

    this.isNotificationsLoading = false,
    this.activityNotifications,
    this.activityNotificationsPagination,

    this.systemNotifications,
  });

  InboxState copyWith({
    bool? isConversationsLoading,
    List<ConversationModel>? conversations,
    PaginationModel? conversationsPagination,

    bool? isNotificationsLoading,
    List<NotificationModel>? activityNotifications,
    PaginationNotificationModel? activityNotificationsPagination,

    List<NotificationModel>? systemNotifications,
  }) {
    return InboxState(
      isConversationsLoading:
          isConversationsLoading ?? this.isConversationsLoading,
      conversations: conversations ?? this.conversations,
      conversationsPagination:
          conversationsPagination ?? this.conversationsPagination,

      isNotificationsLoading:
          isNotificationsLoading ?? this.isNotificationsLoading,
      activityNotifications:
          activityNotifications ?? this.activityNotifications,
      activityNotificationsPagination:
          activityNotificationsPagination ?? this.activityNotificationsPagination,
      systemNotifications: systemNotifications ?? this.systemNotifications,
    );
  }

  @override
  List<Object> get props => [
    isConversationsLoading,
    conversations ?? [],
    conversationsPagination ?? PaginationModel(),
    isNotificationsLoading,
    activityNotifications ?? [],
    activityNotificationsPagination ?? PaginationNotificationModel(),
    systemNotifications ?? [],
  ];
}
