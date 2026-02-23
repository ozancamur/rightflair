import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import '../../cubit/create_post_cubit.dart';

class AddSoundPill extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const AddSoundPill({super.key, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      buildWhen: (prev, curr) => prev.selectedMusic != curr.selectedMusic,
      builder: (context, state) {
        final music = state.selectedMusic;
        final hasMusic = music != null && music.title != null;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * .04,
                  vertical: context.height * .01,
                ),
                constraints: BoxConstraints(maxWidth: context.width * .5),
                decoration: BoxDecoration(
                  color: AppColors.WHITE_30,
                  borderRadius: BorderRadius.circular(context.width * .05),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.music_note,
                      color: AppColors.WHITE,
                      size: context.width * .04,
                    ),
                    SizedBox(width: context.width * .015),
                    Flexible(
                      child: TextComponent(
                        text: hasMusic
                            ? '${music.artist ?? ''} - ${music.title ?? ''}'
                            : AppStrings.CREATE_POST_ADD_MUSIC,
                        tr: !hasMusic,
                        size: const [13],
                        color: AppColors.WHITE,
                        weight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        maxLine: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasMusic) ...[
              SizedBox(width: context.width * .015),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: context.width * .07,
                  height: context.width * .07,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.WHITE_20,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.WHITE,
                    size: context.width * .04,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
