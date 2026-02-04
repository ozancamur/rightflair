import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/stream_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/base/page/base_scaffold.dart';
import '../../../../../core/components/loading.dart';
import '../cubit/inbox_cubit.dart';
import '../cubit/inbox_state.dart';
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

  final _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _setupRealtimeForConversations();
  }

  void _setupRealtimeForConversations() {
    final userId = _supabase.auth.currentUser!.id;

    _channel = _supabase
        .channel('inbox:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'conversations',
          callback: (payload) {
            final StreamConversationLastMessageModel data =
                StreamConversationLastMessageModel().fromJson(
                  payload.newRecord,
                );
            context.read<InboxCubit>().addNewMessage(data: data);
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _channel?.unsubscribe();
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
            : InboxMessagesListWidget(list: state.conversations ?? []),
        InboxNotificationsList(notifications: []),
      ],
    );
  }
}
