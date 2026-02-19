import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/drag_handle.dart';
import '../../../../core/components/text/text.dart';
import '../../../../core/constants/enums/report_reason.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/dialogs/report_success_dialog.dart';
import '../../../../core/extensions/context.dart';
import '../cubit/comments_cubit.dart';

class CommentReportPage extends StatefulWidget {
  final String commentId;
  const CommentReportPage({super.key, required this.commentId});

  static void show(BuildContext context, {required String commentId}) {
    final cubit = context.read<CommentsCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CommentReportPage(commentId: commentId),
      ),
    );
  }

  @override
  State<CommentReportPage> createState() => _CommentReportPageState();
}

class _CommentReportPageState extends State<CommentReportPage> {
  ReportReason? _selectedReason;
  bool _isLoading = false;

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
              text: AppStrings.COMMENTS_REPORT_COMMENT,
              size: FontSizeConstants.X_LARGE,
              weight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
          SizedBox(height: context.height * 0.015),
          ...ReportReason.values.map((reason) => _reasonTile(context, reason)),
          SizedBox(height: context.height * 0.01),
          _submitButton(context),
          SizedBox(height: context.height * 0.04),
        ],
      ),
    );
  }

  Widget _reasonTile(BuildContext context, ReportReason reason) {
    final isSelected = _selectedReason == reason;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedReason = reason;
        });
      },
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
  }

  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (_selectedReason == null || _isLoading)
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  final success = await context
                      .read<CommentsCubit>()
                      .reportComment(
                        commentId: widget.commentId,
                        reason: _selectedReason!,
                      );
                  if (context.mounted) {
                    Navigator.pop(context);
                    if (success && context.mounted) {
                      ReportSuccessDialog.show(context);
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.error,
            disabledBackgroundColor: _isLoading
                ? context.colors.error
                : context.colors.error.withValues(alpha: 0.3),
            padding: EdgeInsets.symmetric(vertical: context.height * 0.015),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.width * 0.03),
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  width: context.width * 0.05,
                  height: context.width * 0.05,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.secondary,
                  ),
                )
              : TextComponent(
                  text: AppStrings.COMMENTS_REPORT,
                  color: context.colors.secondary,
                  size: FontSizeConstants.NORMAL,
                  weight: FontWeight.w600,
                ),
        ),
      ),
    );
  }
}
