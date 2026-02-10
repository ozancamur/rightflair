import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/feature/main/inbox/model/conversation.dart';
import 'package:rightflair/feature/main/inbox/model/last_message.dart';
import 'package:rightflair/feature/main/inbox/model/notification.dart';
import 'package:rightflair/feature/main/inbox/model/stream_message.dart';
import 'package:rightflair/feature/main/inbox/repository/inbox_repository_impl.dart';
import 'package:rightflair/feature/main/inbox/cubit/inbox_state.dart';
import 'package:rightflair/feature/main/profile/model/pagination.dart';

import '../../../../core/constants/route.dart';

class InboxCubit extends Cubit<InboxState> {
  final InboxRepositoryImpl _repo;
  InboxCubit(this._repo) : super(InboxState()) {
    _initConversations();
    _initNotifications();
  }

  Future<void> _initConversations() async {
    emit(state.copyWith(isConversationsLoading: true));
    final chats = await _repo.getConversations(
      pagination: PaginationModel().forConversations(page: 1),
    );

    emit(
      state.copyWith(
        isConversationsLoading: false,
        conversations: chats?.conversations ?? [],
        conversationsPagination: chats?.pagination,
      ),
    );
  }

  Future<void> _initNotifications() async {
    emit(state.copyWith(isNotificationsLoading: true));

    final responseAcitivityNotifications = await _repo.getActivityNotifications(
      page: 1,
      limit: 10,
    );

    emit(
      state.copyWith(
        isNotificationsLoading: false,
        activityNotifications: responseAcitivityNotifications?.notifications,
        activityNotificationsPagination:
            responseAcitivityNotifications?.pagination,
      ),
    );
  }

  Future<void> refreshConversations() async {
    final chats = await _repo.getConversations(
      pagination: PaginationModel().forConversations(page: 1),
    );
    emit(
      state.copyWith(
        conversations: chats?.conversations ?? [],
        conversationsPagination: chats?.pagination,
      ),
    );
  }

  Future<void> refreshNotifications() async {
    final responseAcitivityNotifications = await _repo.getActivityNotifications(
      page: 1,
      limit: 10,
    );
    emit(
      state.copyWith(
        activityNotifications: responseAcitivityNotifications?.notifications,
        activityNotificationsPagination:
            responseAcitivityNotifications?.pagination,
      ),
    );
  }

  void addNewMessage({required StreamConversationLastMessageModel data}) {
    ConversationModel? conversation = state.conversations?.firstWhere(
      (conv) =>
          ((conv.id == data.id) &&
          conv.participant?.id == data.lastMessageSenderId),
    );
    if (conversation == null) {
      debugPrint("Not Found Conversation: ${data.toJson()}");
      return;
    }
    final ConversationModel updatedConversation = conversation.copyWith(
      lastMessage: LastMessageModel(
        content: data.lastMessagePreview,
        imageUrl: null,
        senderId: data.lastMessageSenderId,
        sentAt: data.lastMessageAt,
        isOwnMessage: false,
        isRead: false,
      ),
    );

    final updatedConversations = state.conversations?.map((conv) {
      if (conv.id == updatedConversation.id) {
        return updatedConversation;
      }
      return conv;
    }).toList();
    emit(state.copyWith(conversations: updatedConversations));
  }

  Future<void> loadMoreConversations() async {
    if (state.isLoadingMoreConversations ||
        state.conversationsPagination?.hasNext != true) {
      return;
    }

    emit(state.copyWith(isLoadingMoreConversations: true));

    final nextPage = (state.conversationsPagination?.page ?? 1) + 1;
    final chats = await _repo.getConversations(
      pagination: PaginationModel().forConversations(page: nextPage),
    );

    if (chats != null) {
      final updatedConversations = <ConversationModel>[
        ...state.conversations ?? [],
        ...chats.conversations ?? [],
      ];

      emit(
        state.copyWith(
          isLoadingMoreConversations: false,
          conversations: updatedConversations,
          conversationsPagination: chats.pagination,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMoreConversations: false));
    }
  }

  Future<void> loadMoreActivityNotifications() async {
    if (state.isLoadingMoreNotifications ||
        state.activityNotificationsPagination?.hasNext != true) {
      return;
    }

    emit(state.copyWith(isLoadingMoreNotifications: true));

    final nextPage = (state.activityNotificationsPagination?.page ?? 1) + 1;
    final response = await _repo.getActivityNotifications(
      page: nextPage,
      limit: 10,
    );

    if (response != null) {
      final updatedNotifications = <NotificationModel>[
        ...state.activityNotifications ?? [],
        ...response.notifications ?? [],
      ];

      emit(
        state.copyWith(
          isLoadingMoreNotifications: false,
          activityNotifications: updatedNotifications,
          activityNotificationsPagination: response.pagination,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMoreNotifications: false));
    }
  }

  void toChatPage(
    BuildContext context, {
    required ConversationModel conversation,
  }) {
    _seenLastMessage(cId: conversation.id ?? '');
    context.push(
      RouteConstants.CHAT,
      extra: {
        'conversationId': conversation.id ?? '',
        'otherUserName': conversation.participant?.fullName ?? 'User',
        'otherUserPhoto': conversation.participant?.profilePhotoUrl,
        'otherUserId': conversation.participant?.id ?? '',
      },
    );
  }

  void _seenLastMessage({required String cId}) {
    ConversationModel? conversation = state.conversations?.firstWhere(
      (conv) => ((conv.id == cId)),
    );
    if (conversation == null) return;

    final LastMessageModel updatedLastMessage = conversation.lastMessage!
        .copyWith(isRead: true);
    final ConversationModel updatedConversation = conversation.copyWith(
      lastMessage: updatedLastMessage,
    );

    final updatedConversations = state.conversations?.map((conv) {
      if (conv.id == updatedConversation.id) {
        return updatedConversation;
      }
      return conv;
    }).toList();
    emit(state.copyWith(conversations: updatedConversations));
  }
}
