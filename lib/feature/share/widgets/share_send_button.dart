import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';

class ShareSendButtonWidget extends StatelessWidget {
  final String userId;
  final String? postId;
  const ShareSendButtonWidget({super.key, required this.userId, this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareCubit, ShareState>(
      buildWhen: (previous, current) =>
          previous.selectedUser != current.selectedUser ||
          previous.isSending != current.isSending,
      builder: (context, state) {
        final hasSelection = state.selectedUser != null;

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
                        onPressed: state.isSending
                            ? null
                            : () => _onSend(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          disabledBackgroundColor: context.colors.primary
                              .withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isSending
                            ? SizedBox(
                                width: context.width * 0.05,
                                height: context.width * 0.05,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: context.colors.secondary,
                                ),
                              )
                            : Text(
                                AppStrings.SHARE_DIALOG_SHARE_TO_CHAT.tr(),
                                style: TextStyle(
                                  color: context.colors.secondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
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

  Future<void> _onSend(BuildContext context) async {
    final cubit = context.read<ShareCubit>();
    if (postId != null && postId!.isNotEmpty) {
      await cubit.sharePost(referencedPostId: postId!);
    } else {
      await cubit.shareProfile(referencedUserId: userId);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
