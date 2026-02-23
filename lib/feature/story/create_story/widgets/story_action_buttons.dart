import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/color/color.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../cubit/create_story_cubit.dart';

class StoryActionButtons extends StatelessWidget {
  final VoidCallback? onRetake;
  final VoidCallback? onShare;

  const StoryActionButtons({super.key, this.onRetake, this.onShare});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStoryCubit, CreateStoryState>(
      builder: (context, state) {
        final isLoading = state.isLoading == true;
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: isLoading ? null : onRetake,
                child: Container(
                  height: context.height * .06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.width * .06),
                    border: Border.all(color: AppColors.WHITE, width: 1.5),
                  ),
                  child: Center(
                    child: TextComponent(
                      text: AppStrings.CREATE_POST_CAMERA_RETAKE,
                      size: const [15],
                      color: AppColors.WHITE,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.width * .03),
            Expanded(
              child: GestureDetector(
                onTap: isLoading ? null : onShare,
                child: Container(
                  height: context.height * .06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.width * .06),
                    gradient: LinearGradient(
                      colors: [AppColors.ORANGE, AppColors.YELLOW],
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: context.width * .055,
                            height: context.width * .055,
                            child: const CircularProgressIndicator(
                              color: AppColors.WHITE,
                              strokeWidth: 2.5,
                            ),
                          )
                        : TextComponent(
                            text: AppStrings.PROFILE_EDIT_STORY_SHARE,
                            size: const [15],
                            color: AppColors.WHITE,
                            weight: FontWeight.w600,
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
