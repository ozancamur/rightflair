import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/page/base_scaffold.dart';
import '../../../../../core/components/loading.dart';
import '../cubit/inbox_cubit.dart';
import '../cubit/inbox_state.dart';
import '../model/conversations.dart';
import '../widgets/inbox_appbar.dart';
import '../widgets/messages/inbox_messages_list.dart';
import '../widgets/notifications/inbox_notifications_list.dart';
import '../widgets/inbox_tab_bars.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InboxCubit, InboxState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: const InboxAppBarWidget(),
          body: Column(
            children: [
              InboxTabBarsWidget(controller: _tabController),
              Expanded(child: _check(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _check(InboxState state) {
    return state.isLoading ? LoadingComponent() : _body(state);
  }

  TabBarView _body(InboxState state) {
    return TabBarView(
      controller: _tabController,
      children: [
        state.conversations == null
            ? SizedBox.shrink()
            : InboxMessagesListWidget(data: state.conversations ?? ConversationsModel()),
        InboxNotificationsList(notifications: []),
      ],
    );
  }
}
