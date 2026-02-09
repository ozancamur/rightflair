import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/conversation.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/last_message.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/stream_message.dart';
import 'package:rightflair/feature/navigation/page/inbox/repository/inbox_repository_impl.dart';
import 'package:rightflair/feature/navigation/page/inbox/cubit/inbox_state.dart';
import 'package:rightflair/feature/navigation/page/profile/model/pagination.dart';

import '../../../../../core/constants/route.dart';

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

    final responseAcitivityNotifications = await _repo
        .getActivityNotifications();

    emit(
      state.copyWith(
        isNotificationsLoading: false,
        activityNotifications: responseAcitivityNotifications?.notifications,
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
