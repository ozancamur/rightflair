import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/chat/model/chat_message.dart';
import 'package:rightflair/feature/chat/model/chat_pagination.dart';
import 'package:rightflair/feature/chat/model/chat_request.dart';
import 'package:rightflair/feature/chat/model/message_sender.dart';
import 'package:rightflair/feature/chat/model/send_message_request.dart';
import 'package:rightflair/feature/chat/repository/chat_repository_impl.dart';

import '../../../core/constants/enums/message_send_status.dart';
import '../model/new_message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepositoryImpl _repo;
  ChatCubit(this._repo) : super(ChatState.initial());

  Future<void> init({
    int page = 1,
    required String cId,
    required String ouid,
    required String otherUsername,
    required String otherPhotoUrl,
  }) async {
    final MessageSenderModel sender = MessageSenderModel(
      id: ouid,
      username: otherUsername,
      profilePhotoUrl: otherPhotoUrl,
    );
    emit(state.copyWith(isLoading: true, cId: cId, sender: sender));

    final request = ChatRequestModel(
      conversationId: cId,
      page: page,
      limit: 50,
    );

    final response = await _repo.fetchMessages(request: request);

    if (response != null) {
      emit(
        state.copyWith(
          isLoading: false,
          messages: response.messages ?? [],
          pagination: response.pagination,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false, error: 'Failed to load messages'));
    }
  }

  Future<void> loadMoreMessages() async {
    if (state.isLoadingMore || state.pagination?.hasNext != true) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = (state.pagination?.page ?? 0) + 1;
    final request = ChatRequestModel(
      conversationId: state.cId,
      page: nextPage,
      limit: 50,
      beforeMessageId: state.pagination?.oldestMessageId,
    );

    final response = await _repo.fetchMessages(request: request);

    if (response != null) {
      final updatedMessages = [...state.messages, ...?response.messages];
      emit(
        state.copyWith(
          isLoadingMore: false,
          messages: updatedMessages,
          pagination: response.pagination,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    if (content.trim().isEmpty && imageUrl == null) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final optimisticMessage = ChatMessageModel(
      id: tempId,
      content: content.trim().isNotEmpty ? content.trim() : null,
      imageUrl: imageUrl,
      isOwnMessage: true,
      isRead: false,
      createdAt: DateTime.now(),
      sendStatus: MessageSendStatus.sending,
    );

    final messagesWithOptimistic = [...state.messages, optimisticMessage];
    emit(state.copyWith(messages: messagesWithOptimistic));

    final request = SendMessageRequestModel(
      conversationId: state.cId,
      content: content.trim().isNotEmpty ? content.trim() : null,
      imageUrl: imageUrl,
    );

    final response = await _repo.sendMessage(request: request);

    if (response != null && response.message != null) {
      final updatedMessages = state.messages.map((msg) {
        if (msg.id == tempId) {
          return response.message!.copyWith(sendStatus: MessageSendStatus.sent);
        }
        return msg;
      }).toList();
      emit(state.copyWith(messages: updatedMessages));
    } else {
      final updatedMessages = state.messages.map((msg) {
        if (msg.id == tempId) {
          return msg.copyWith(sendStatus: MessageSendStatus.failed);
        }
        return msg;
      }).toList();
      emit(state.copyWith(messages: updatedMessages));
    }
  }

  Future<void> resendMessage(ChatMessageModel failedMessage) async {
    if (failedMessage.sendStatus != MessageSendStatus.failed) return;

    final updatedMessages = state.messages.map((msg) {
      if (msg.id == failedMessage.id) {
        return msg.copyWith(sendStatus: MessageSendStatus.sending);
      }
      return msg;
    }).toList();
    emit(state.copyWith(messages: updatedMessages));

    final request = SendMessageRequestModel(
      conversationId: state.cId,
      content: failedMessage.content,
      imageUrl: failedMessage.imageUrl,
    );

    final response = await _repo.sendMessage(request: request);

    if (response != null && response.message != null) {
      final newMessages = state.messages.map((msg) {
        if (msg.id == failedMessage.id) {
          return response.message!.copyWith(sendStatus: MessageSendStatus.sent);
        }
        return msg;
      }).toList();
      emit(state.copyWith(messages: newMessages));
    } else {
      final newMessages = state.messages.map((msg) {
        if (msg.id == failedMessage.id) {
          return msg.copyWith(sendStatus: MessageSendStatus.failed);
        }
        return msg;
      }).toList();
      emit(state.copyWith(messages: newMessages));
    }
  }

  void deleteFailedMessage(String messageId) {
    final updatedMessages = state.messages
        .where((msg) => msg.id != messageId)
        .toList();
    emit(state.copyWith(messages: updatedMessages));
  }

  void addNewMessage({required NewMessageModel newMessage}) {
    final ChatMessageModel message = newMessage.convertToChatMessageModel(
      sender: state.sender,
    );
    final updatedMessages = [...state.messages, message];
    emit(state.copyWith(messages: updatedMessages));
  }
}
