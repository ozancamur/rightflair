import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extensions/context.dart';
import '../../cubit/inbox_cubit.dart';
import '../../model/conversation.dart';
import 'inbox_message_item.dart';

class InboxMessagesListWidget extends StatefulWidget {
  final List<ConversationModel> list;
  final bool isLoadingMore;
  const InboxMessagesListWidget({
    super.key,
    required this.list,
    required this.isLoadingMore,
  });

  @override
  State<InboxMessagesListWidget> createState() =>
      _InboxMessagesListWidgetState();
}

class _InboxMessagesListWidgetState extends State<InboxMessagesListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final cubit = context.read<InboxCubit>();
      cubit.loadMoreConversations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<InboxCubit>().refreshConversations();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          vertical: context.height * 0.02,
          horizontal: context.width * .03,
        ),
        itemCount: widget.list.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == widget.list.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colors.primary,
                ),
              ),
            );
          }
          final ConversationModel conversation = widget.list[index];
          return InboxMessageItem(conversation: conversation);
        },
      ),
    );
  }
}
