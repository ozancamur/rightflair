import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/string.dart';
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                constraints: const BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  color: AppColors.WHITE_15,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.music_note,
                      color: AppColors.WHITE,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        hasMusic
                            ? '${music.artist ?? ''} - ${music.title ?? ''}'
                            : AppStrings.CREATE_POST_ADD_MUSIC.tr(),
                        style: const TextStyle(
                          color: AppColors.WHITE,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasMusic) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.WHITE_20,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.WHITE,
                    size: 16,
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
