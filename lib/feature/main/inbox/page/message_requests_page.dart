import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/loading.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../cubit/inbox_cubit.dart';
import '../cubit/inbox_state.dart';
import '../widgets/message_requests/message_request_item.dart';

class MessageRequestsPage extends StatefulWidget {
  const MessageRequestsPage({super.key});

  @override
  State<MessageRequestsPage> createState() => _MessageRequestsPageState();
}

class _MessageRequestsPageState extends State<MessageRequestsPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<InboxCubit>().initMessageRequests();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<InboxCubit>().loadMoreMessageRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      canPop: true,
      appBar: AppBar(
        backgroundColor: context.colors.secondary,
        title: Text(
          AppStrings.INBOX_MESSAGE_REQUESTS.tr(),
          style: TextStyle(
            color: context.colors.primary,
            fontSize: FontSizeConstants.XX_LARGE.first,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.colors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<InboxCubit, InboxState>(
        builder: (context, state) {
          if (state.isMessageRequestsLoading) {
            return LoadingComponent();
          }

          final requests = state.messageRequests ?? [];
          if (requests.isEmpty) {
            return Center(
              child: Text(
                'No message requests',
                style: TextStyle(
                  color: context.colors.tertiary,
                  fontSize: FontSizeConstants.NORMAL.first,
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: context.colors.primary,
            backgroundColor: context.colors.secondary,
            onRefresh: () async {
              await context.read<InboxCubit>().refreshMessageRequests();
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                vertical: context.height * 0.02,
                horizontal: context.width * .03,
              ),
              itemCount:
                  requests.length +
                  (state.isLoadingMoreMessageRequests ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == requests.length) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.height * 0.02,
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.primary,
                      ),
                    ),
                  );
                }
                return MessageRequestItem(request: requests[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
