import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/enums/notification_type.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/feature/main/inbox/widgets/notifications/inbox_notification_item.dart';

import '../../../../../core/extensions/context.dart';
import '../../cubit/inbox_cubit.dart';
import '../../model/notification.dart';
import '../inbox_notification_button.dart';
import '../inbox_notification_keep.dart';

class InboxNotificationsList extends StatefulWidget {
  final List<NotificationModel> notifications;
  final bool isLoadingMore;
  const InboxNotificationsList({
    super.key,
    required this.notifications,
    required this.isLoadingMore,
  });

  @override
  State<InboxNotificationsList> createState() => _InboxNotificationsListState();
}

class _InboxNotificationsListState extends State<InboxNotificationsList> {
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
      cubit.loadMoreActivityNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height,
      width: context.width,
      child: Stack(
        children: [
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<InboxCubit>().refreshNotifications();
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  right: context.width * 0.04,
                  left: context.width * 0.04,
                  bottom: context.height * .3,
                ),
                itemCount:
                    widget.notifications.length +
                    1 +
                    (widget.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0) return _zero(context);
                  if (index == widget.notifications.length + 1) {
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
                  return InboxNotificationItem(
                    notification: widget.notifications[index - 1],
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: context.height * .3,
              width: context.width,
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
              decoration: BoxDecoration(color: context.colors.secondary),
              child: Column(
                children: [
                  InboxNotificationButtonWidget(
                    onTap: () => context.push(RouteConstants.NEW_FOLLOWERS),
                    type: NotificationType.NEW_FOLLOWER,
                    title: AppStrings.INBOX_NEW_FOLLOWERS_TITLE,
                    content: AppStrings.INBOX_NEW_FOLLOWERS_INFO,
                  ),
                  InboxNotificationButtonWidget(
                    onTap: () =>
                        context.push(RouteConstants.SYSTEM_NOTIFICATIONS),
                    type: NotificationType.SYSTEM_UPDATE,
                    title: AppStrings.INBOX_SYSTEM_NOTIFICATIONS_TITLE,
                    content: AppStrings.INBOX_SYSTEM_NOTIFICATIONS_INFO,
                  ),
                  const InboxNotificationKeep(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _zero(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.height * 0.02,
        bottom: context.height * 0.01,
      ),
      child: TextComponent(
        text: AppStrings.INBOX_TODAYS_ACTIVITY,
        size: FontSizeConstants.LARGE,
        weight: FontWeight.w600,
        align: TextAlign.start,
        color: context.colors.primary,
      ),
    );
  }
}
