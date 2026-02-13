import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../cubit/create_post_cubit.dart';
import 'create_post_option_tile.dart';

import '../../../location/page/location_page.dart';
import '../model/music.dart';
import 'dialog_add_music.dart';

class CreatePostOptionsWidget extends StatelessWidget {
  final bool isAnonymous;
  final bool allowComments;
  final String? selectedLocation;
  final MusicModel? selectedMusic;

  const CreatePostOptionsWidget({
    super.key,
    required this.isAnonymous,
    required this.allowComments,
    this.selectedLocation,
    this.selectedMusic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLocationTile(context),
        _buildMusicTile(context),
        _buildAnonymousTile(context),
        _buildCommentsTile(context),
      ],
    );
  }

  Widget _buildLocationTile(BuildContext context) {
    return CreatePostOptionTile(
      title: AppStrings.CREATE_POST_LOCATION,
      subtitle: selectedLocation,
      iconPath: AppIcons.LOCATION,
      trailing: SvgPicture.asset(
        AppIcons.ARROW_RIGHT,
        colorFilter: ColorFilter.mode(
          context.colors.onPrimary,
          BlendMode.srcIn,
        ),
        height: context.height * 0.015,
      ),
      onTap: () async {
        final result = await Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => LocationPage()),
        );
        if (result != null && context.mounted) {
          context.read<CreatePostCubit>().updateLocation(result);
        }
      },
    );
  }

  Widget _buildMusicTile(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return CreatePostOptionTile(
          title: 'Müzik Ekle',
          subtitle: selectedMusic?.displayName,
          iconPath: null,
          icon: Icon(Icons.music_note, color: Colors.white),
          trailing: selectedMusic != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Play/Pause Button
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        state.isPlayingMusic ? Icons.pause : Icons.play_arrow,
                        color: context.colors.onPrimary,
                        size: 24,
                      ),
                      onPressed: () {
                        context.read<CreatePostCubit>().togglePlayPause();
                      },
                    ),
                    SizedBox(width: context.width * 0.02),
                    // Change Music Button
                    GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet<MusicModel>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const AddMusicBottomSheet(),
                        );
                        if (result != null && context.mounted) {
                          context.read<CreatePostCubit>().setSelectedMusic(
                            result,
                          );
                        }
                      },
                      child: SvgPicture.asset(
                        AppIcons.ARROW_RIGHT,
                        colorFilter: ColorFilter.mode(
                          context.colors.onPrimary,
                          BlendMode.srcIn,
                        ),
                        height: context.height * 0.015,
                      ),
                    ),
                  ],
                )
              : SvgPicture.asset(
                  AppIcons.ARROW_RIGHT,
                  colorFilter: ColorFilter.mode(
                    context.colors.onPrimary,
                    BlendMode.srcIn,
                  ),
                  height: context.height * 0.015,
                ),
          onTap: selectedMusic == null
              ? () async {
                  final result = await showModalBottomSheet<MusicModel>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const AddMusicBottomSheet(),
                  );
                  if (result != null && context.mounted) {
                    context.read<CreatePostCubit>().setSelectedMusic(result);
                  }
                }
              : null,
        );
      },
    );
  }

  Widget _buildAnonymousTile(BuildContext context) {
    return CreatePostOptionTile(
      title: AppStrings.CREATE_POST_ANONYMOUSLY,
      subtitle: AppStrings.CREATE_POST_ANONYMOUSLY_SUBTITLE,
      iconPath: AppIcons.ANONYMOUS,
      trailing: Switch.adaptive(
        value: isAnonymous,
        activeColor: context.colors.inverseSurface,
        onChanged: (value) async => await context
            .read<CreatePostCubit>()
            .toggleAnonymous(context, value),
      ),
    );
  }

  Widget _buildCommentsTile(BuildContext context) {
    return CreatePostOptionTile(
      title: AppStrings.CREATE_POST_ALLOW_COMMENTS,
      iconPath: AppIcons.COMMENTS,
      trailing: Switch.adaptive(
        padding: EdgeInsets.zero,
        value: allowComments,
        activeColor: context.colors.inverseSurface,
        onChanged: (value) =>
            context.read<CreatePostCubit>().toggleAllowComments(value),
      ),
    );
  }
}
