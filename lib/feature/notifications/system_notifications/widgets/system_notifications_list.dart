import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../../core/extensions/context.dart';
import '../cubit/system_notifications_cubit.dart';
import 'system_notification_item.dart';

class SystemNotificationsListWidget extends StatefulWidget {
  const SystemNotificationsListWidget({super.key});

  @override
  State<SystemNotificationsListWidget> createState() =>
      _SystemNotificationsListWidgetState();
}

class _SystemNotificationsListWidgetState
    extends State<SystemNotificationsListWidget> {
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
      final cubit = context.read<SystemNotificationsCubit>();
      cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemNotificationsCubit, SystemNotificationsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return LoadingComponent();
        }
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<SystemNotificationsCubit>().refresh();
          },
          child: SizedBox(
            height: context.height,
            width: context.width,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.04,
                vertical: context.height * 0.02,
              ),
              itemCount:
                  (state.notifications?.length ?? 0) +
                  (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.notifications?.length) {
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
                return SystemNotificationItem(
                  notification: state.notifications![index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
