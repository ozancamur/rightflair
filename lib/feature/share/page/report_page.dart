import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/drag_handle.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/enums/report_reason.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';
import '../widgets/share_report_button.dart';

class ReportPage extends StatelessWidget {
  final String? postId;
  final String userId;
  const ReportPage({super.key, required this.postId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.width * 0.05),
          topRight: Radius.circular(context.width * 0.05),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DragHandleComponent(),
          SizedBox(height: context.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
            child: TextComponent(
              text: AppStrings.SHARE_DIALOG_REPORT_POST,
              size: FontSizeConstants.X_LARGE,
              weight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
          SizedBox(height: context.height * 0.015),
          ...ReportReason.values.map((reason) => _reasonTile(context, reason)),
          SizedBox(height: context.height * 0.01),
          ShareReportButtonWidget(postId: postId, userId: userId),
          SizedBox(height: context.height * 0.04),
        ],
      ),
    );
  }

  Widget _reasonTile(BuildContext context, ReportReason reason) {
    return BlocBuilder<ShareCubit, ShareState>(
      buildWhen: (prev, curr) =>
          prev.selectedReportReason != curr.selectedReportReason,
      builder: (context, state) {
        final isSelected = state.selectedReportReason == reason;

        return InkWell(
          onTap: () => context.read<ShareCubit>().selectReportReason(reason),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.05,
              vertical: context.height * 0.015,
            ),
            color: isSelected
                ? context.colors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: TextComponent(
                    text: reason.label,
                    tr: false,
                    size: FontSizeConstants.NORMAL,
                    weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? context.colors.error
                        : context.colors.primary,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: context.colors.error,
                    size: context.width * 0.05,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
