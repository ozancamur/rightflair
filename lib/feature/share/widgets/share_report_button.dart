import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/string.dart';
import '../../../core/dialogs/report_success_dialog.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';

class ShareReportButtonWidget extends StatefulWidget {
  final String? postId;
  final String userId;
  const ShareReportButtonWidget({super.key, this.postId, required this.userId});

  @override
  State<ShareReportButtonWidget> createState() =>
      _ShareReportButtonWidgetState();
}

class _ShareReportButtonWidgetState extends State<ShareReportButtonWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareCubit, ShareState>(
      buildWhen: (prev, curr) =>
          prev.selectedReportReason != curr.selectedReportReason,
      builder: (context, state) {
        final hasSelection = state.selectedReportReason != null;

        return AnimatedOpacity(
          opacity: hasSelection ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: hasSelection
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.width * 0.04,
                      vertical: context.height * 0.01,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: context.height * 0.055,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() => _isLoading = true);
                                if (widget.postId != null &&
                                    widget.postId != "") {
                                  await context.read<ShareCubit>().reportPost(
                                    widget.postId!,
                                  );
                                } else {
                                  await context.read<ShareCubit>().reportUser(
                                    widget.userId,
                                  );
                                }
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                                if (context.mounted) {
                                  ReportSuccessDialog.show(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.error,
                          disabledBackgroundColor: context.colors.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                                text: AppStrings.SHARE_DIALOG_REPORT_POST,
                                size: FontSizeConstants.NORMAL,
                                weight: FontWeight.w600,
                                color: context.colors.secondary,
                              ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
