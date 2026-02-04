import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/conversation.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/last_message.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/stream_message.dart';
import 'package:rightflair/feature/navigation/page/inbox/repository/inbox_repository_impl.dart';
import 'package:rightflair/feature/navigation/page/inbox/cubit/inbox_state.dart';
import 'package:rightflair/feature/navigation/page/profile/model/pagination.dart';

class InboxCubit extends Cubit<InboxState> {
  final InboxRepositoryImpl _repo;
  InboxCubit(this._repo) : super(InboxState()) {
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    emit(state.copyWith(isLoading: true));
    final response = await _repo.fetchConversations(
      pagination: PaginationModel().forConversations(page: 1),
    );
    emit(
      state.copyWith(
        isLoading: false,
        conversations: response?.conversations ?? [],
        pagination: response?.pagination,
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
}
