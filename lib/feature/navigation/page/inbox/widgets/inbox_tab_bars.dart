import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/string.dart';

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
        indicatorColor: AppDarkColors.PRIMARY,
        indicatorWeight: 2.0,
        labelColor: AppDarkColors.PRIMARY,
        unselectedLabelColor: AppDarkColors.GREY,
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
