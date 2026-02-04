import 'package:equatable/equatable.dart';

import '../../profile/model/pagination.dart';
import '../model/conversation.dart';

class InboxState extends Equatable {
  final bool isLoading;
  final List<ConversationModel>? conversations;
  final PaginationModel? pagination;
  const InboxState({
    this.isLoading = false,
    this.conversations,
    this.pagination,
  });

  InboxState copyWith({
    bool? isLoading,
    List<ConversationModel>? conversations,
    PaginationModel? pagination,
  }) {
    return InboxState(
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
      pagination: pagination ?? this.pagination,
    );
  } /*  */

  @override
  List<Object> get props => [
    isLoading,
    conversations ?? [],
    pagination ?? PaginationModel(),
  ];
}
