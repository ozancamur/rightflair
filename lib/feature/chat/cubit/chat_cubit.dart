import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/chat/model/chat_message.dart';
import 'package:rightflair/feature/chat/model/chat_pagination.dart';
import 'package:rightflair/feature/chat/model/chat_request.dart';
import 'package:rightflair/feature/chat/model/send_message_request.dart';
import 'package:rightflair/feature/chat/repository/chat_repository_impl.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepositoryImpl _repo;
  final String conversationId;
  final String otherUserName;
  final String? otherUserPhoto;
  final String otherUserId;

  ChatCubit({
    required this.conversationId,
    required this.otherUserName,
    this.otherUserPhoto,
    required this.otherUserId,
    ChatRepositoryImpl? repo,
  }) : _repo = repo ?? ChatRepositoryImpl(),
       super(ChatState.initial()) {
    _loadMessages();
  }

  Future<void> _loadMessages({int page = 1}) async {
    emit(state.copyWith(isLoading: true));

    final request = ChatRequestModel(
      conversationId: conversationId,
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
      conversationId: conversationId,
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

    // Create a temporary message ID for optimistic update
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    // Create optimistic message
    final optimisticMessage = ChatMessageModel(
      id: tempId,
      content: content.trim().isNotEmpty ? content.trim() : null,
      imageUrl: imageUrl,
      isOwnMessage: true,
      isRead: false,
      createdAt: DateTime.now(),
      sendStatus: MessageSendStatus.sending,
    );

    // Add optimistic message to list immediately
    final messagesWithOptimistic = [...state.messages, optimisticMessage];
    emit(state.copyWith(messages: messagesWithOptimistic));

    final request = SendMessageRequestModel(
      conversationId: conversationId,
      content: content.trim().isNotEmpty ? content.trim() : null,
      imageUrl: imageUrl,
    );

    final response = await _repo.sendMessage(request: request);

    if (response != null && response.message != null) {
      // Replace optimistic message with real message
      final updatedMessages = state.messages.map((msg) {
        if (msg.id == tempId) {
          return response.message!.copyWith(sendStatus: MessageSendStatus.sent);
        }
        return msg;
      }).toList();
      emit(state.copyWith(messages: updatedMessages));
    } else {
      // Mark message as failed
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

    // Update status to sending
    final updatedMessages = state.messages.map((msg) {
      if (msg.id == failedMessage.id) {
        return msg.copyWith(sendStatus: MessageSendStatus.sending);
      }
      return msg;
    }).toList();
    emit(state.copyWith(messages: updatedMessages));

    final request = SendMessageRequestModel(
      conversationId: conversationId,
      content: failedMessage.content,
      imageUrl: failedMessage.imageUrl,
    );

    final response = await _repo.sendMessage(request: request);

    if (response != null && response.message != null) {
      // Replace with real message
      final newMessages = state.messages.map((msg) {
        if (msg.id == failedMessage.id) {
          return response.message!.copyWith(sendStatus: MessageSendStatus.sent);
        }
        return msg;
      }).toList();
      emit(state.copyWith(messages: newMessages));
    } else {
      // Mark as failed again
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

  Future<void> refresh() async {
    await _loadMessages();
  }
}
