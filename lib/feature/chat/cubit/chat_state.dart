part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSending;

  final String cId;
  final MessageSenderModel sender;
  final List<ChatMessageModel> messages;
  final ChatPaginationModel? pagination;

  final String? error;

  const ChatState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.isSending,

    required this.cId,
    required this.sender,
    required this.messages,
    this.pagination,

    this.error,
  });

  factory ChatState.initial() {
    return ChatState(
      isLoading: false,
      isLoadingMore: false,
      isSending: false,

      cId: '',
      sender: MessageSenderModel(),
      messages: [],
      pagination: null,

      error: null,
    );
  }

  ChatState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSending,
    String? cId,
    MessageSenderModel? sender,
    List<ChatMessageModel>? messages,
    ChatPaginationModel? pagination,
    String? error,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSending: isSending ?? this.isSending,
      cId: cId ?? this.cId,
      sender: sender ?? this.sender,
      messages: messages ?? this.messages,
      pagination: pagination ?? this.pagination,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    isSending,
    cId,
    sender,
    messages,
    pagination,
    error,
  ];
}
