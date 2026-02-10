import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class InboxTabBarsWidget extends StatelessWidget {
  final TabController controller;
  const InboxTabBarsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: TabBar(
        controller: controller,
        indicatorColor: context.colors.primary,
        indicatorWeight: 2.0,
        labelColor: context.colors.primary,
        unselectedLabelColor: context.colors.tertiary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        tabs: [
          Tab(text: AppStrings.INBOX_MESSAGES.tr()),
          Tab(text: AppStrings.INBOX_NOTIFICATIONS.tr()),
        ],
      ),
    );
  }
}
