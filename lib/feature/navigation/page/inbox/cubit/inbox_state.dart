import 'package:equatable/equatable.dart';

import '../model/conversations.dart';

class InboxState extends Equatable {
  final bool isLoading;
  final ConversationsModel? conversations;
  const InboxState({this.isLoading = false, this.conversations});

  InboxState copyWith({bool? isLoading, ConversationsModel? conversations}) {
    return InboxState(
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
    );
  } /*  */

  @override
  List<Object> get props => [isLoading, conversations ?? ConversationsModel()];
}
