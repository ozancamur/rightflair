import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';

class ShareReportButtonWidget extends StatelessWidget {
  final String? postId;
  final String userId;
  const ShareReportButtonWidget({super.key, this.postId, required this.userId});

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
                        onPressed: () {
                          if (postId != null && postId != "") {
                            context.read<ShareCubit>().reportPost(postId!).then(
                              (_) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            context.read<ShareCubit>().reportUser(userId).then((
                              _,
                            ) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: TextComponent(
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
