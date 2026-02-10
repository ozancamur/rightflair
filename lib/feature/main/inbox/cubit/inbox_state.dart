import 'package:equatable/equatable.dart';
import 'package:rightflair/feature/main/inbox/model/pagination_notification.dart';

import '../../profile/model/pagination.dart';
import '../model/conversation.dart';
import '../model/notification.dart';

class InboxState extends Equatable {
  final bool isConversationsLoading;
  final bool isLoadingMoreConversations;
  final List<ConversationModel>? conversations;
  final PaginationModel? conversationsPagination;

  final bool isNotificationsLoading;
  final bool isLoadingMoreNotifications;
  final List<NotificationModel>? activityNotifications;
  final PaginationNotificationModel? activityNotificationsPagination;

  const InboxState({
    this.isConversationsLoading = false,
    this.isLoadingMoreConversations = false,
    this.conversations,
    this.conversationsPagination,

    this.isNotificationsLoading = false,
    this.isLoadingMoreNotifications = false,
    this.activityNotifications,
    this.activityNotificationsPagination,
  });

  InboxState copyWith({
    bool? isConversationsLoading,
    bool? isLoadingMoreConversations,
    List<ConversationModel>? conversations,
    PaginationModel? conversationsPagination,

    bool? isNotificationsLoading,
    bool? isLoadingMoreNotifications,
    List<NotificationModel>? activityNotifications,
    PaginationNotificationModel? activityNotificationsPagination,
  }) {
    return InboxState(
      isConversationsLoading:
          isConversationsLoading ?? this.isConversationsLoading,
      isLoadingMoreConversations:
          isLoadingMoreConversations ?? this.isLoadingMoreConversations,
      conversations: conversations ?? this.conversations,
      conversationsPagination:
          conversationsPagination ?? this.conversationsPagination,

      isNotificationsLoading:
          isNotificationsLoading ?? this.isNotificationsLoading,
      isLoadingMoreNotifications:
          isLoadingMoreNotifications ?? this.isLoadingMoreNotifications,
      activityNotifications:
          activityNotifications ?? this.activityNotifications,
      activityNotificationsPagination:
          activityNotificationsPagination ??
          this.activityNotificationsPagination,
    );
  }

  @override
  List<Object> get props => [
    isConversationsLoading,
    isLoadingMoreConversations,
    conversations ?? [],
    conversationsPagination ?? PaginationModel(),
    isNotificationsLoading,
    isLoadingMoreNotifications,
    activityNotifications ?? [],
    activityNotificationsPagination ?? PaginationNotificationModel(),
  ];
}
