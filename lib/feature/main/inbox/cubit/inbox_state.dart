import 'package:equatable/equatable.dart';
import 'package:rightflair/feature/main/inbox/model/pagination_notification.dart';

import '../../profile/model/pagination.dart';
import '../model/conversation.dart';
import '../model/message_request.dart';
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

  final bool isMessageRequestsLoading;
  final bool isLoadingMoreMessageRequests;
  final List<MessageRequestModel>? messageRequests;
  final PaginationNotificationModel? messageRequestsPagination;

  const InboxState({
    this.isConversationsLoading = false,
    this.isLoadingMoreConversations = false,
    this.conversations,
    this.conversationsPagination,

    this.isNotificationsLoading = false,
    this.isLoadingMoreNotifications = false,
    this.activityNotifications,
    this.activityNotificationsPagination,

    this.isMessageRequestsLoading = false,
    this.isLoadingMoreMessageRequests = false,
    this.messageRequests,
    this.messageRequestsPagination,
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

    bool? isMessageRequestsLoading,
    bool? isLoadingMoreMessageRequests,
    List<MessageRequestModel>? messageRequests,
    PaginationNotificationModel? messageRequestsPagination,
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

      isMessageRequestsLoading:
          isMessageRequestsLoading ?? this.isMessageRequestsLoading,
      isLoadingMoreMessageRequests:
          isLoadingMoreMessageRequests ?? this.isLoadingMoreMessageRequests,
      messageRequests: messageRequests ?? this.messageRequests,
      messageRequestsPagination:
          messageRequestsPagination ?? this.messageRequestsPagination,
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
    isMessageRequestsLoading,
    isLoadingMoreMessageRequests,
    messageRequests ?? [],
    messageRequestsPagination ?? PaginationNotificationModel(),
  ];
}
