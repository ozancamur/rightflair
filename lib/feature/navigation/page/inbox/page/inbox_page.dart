import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/base_scaffold.dart';
import '../../../../../core/components/error_message.dart';
import '../../../../../core/components/loading.dart';
import '../cubit/inbox_cubit.dart';
import '../cubit/inbox_state.dart';
import '../repository/inbox_repository_impl.dart';
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
    return BlocProvider(
      create: (context) => InboxCubit(InboxRepositoryImpl())..loadMessages(),
      child: BlocBuilder<InboxCubit, InboxState>(
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
      ),
    );
  }

  Widget _check(InboxState state) {
    if (state is InboxLoading) {
      return const LoadingComponent();
    } else if (state is InboxLoaded) {
      return _body(state);
    } else if (state is InboxError) {
      return ErrorMessageComponent(message: state.message);
    }
    return const SizedBox.shrink();
  }

  TabBarView _body(InboxLoaded state) {
    return TabBarView(
      controller: _tabController,
      children: [
        InboxMessagesListWidget(messages: state.messages),
        InboxNotificationsList(notifications: state.notifications),
      ],
    );
  }
}
