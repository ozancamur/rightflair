import 'package:flutter/material.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../dialog/dialog_report.dart';
import 'share_button.dart';

class ShareReportPostButtonWidget extends StatelessWidget {
  final String postId;
  final String userId;
  const ShareReportPostButtonWidget({
    super.key,
    required this.postId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return ShareButtonWidget(
      icon: AppIcons.REPORT,
      label: AppStrings.SHARE_DIALOG_REPORT_POST,
      onTap: () =>
          showReportPostDialog(context, postId: postId, userId: userId),
      color: context.colors.error,
    );
  }
}
