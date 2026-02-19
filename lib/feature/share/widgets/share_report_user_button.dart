import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../dialog/dialog_report.dart';
import 'share_button.dart';

class ShareReportUserButtonWidget extends StatelessWidget {
  final String userId;
  const ShareReportUserButtonWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ShareButtonWidget(
      icon: AppIcons.REPORT,
      label: AppStrings.SHARE_DIALOG_REPORT_USER.tr(),
      onTap: () => showReportPostDialog(context, userId: userId),
      color: context.colors.error,
    );
  }
}
