import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../create_post/model/music.dart';
import '../cubit/post_update_cubit.dart';

class PostUpdateMusicWidget extends StatelessWidget {
  const PostUpdateMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostUpdateCubit, PostUpdateState>(
      builder: (context, state) {
        final hasMusic = state.selectedMusic != null;

        return GestureDetector(
          onTap: () => _showMusicBottomSheet(context),
          child: Container(
            padding: EdgeInsets.all(context.width * 0.04),
            decoration: BoxDecoration(
              color: context.colors.shadow,
              borderRadius: BorderRadius.circular(context.width * 0.04),
              border: Border.all(color: context.colors.primaryFixedDim),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.music_note,
                  color: context.colors.primary,
                  size: context.width * 0.06,
                ),
                SizedBox(width: context.width * 0.04),
                Expanded(
                  child: hasMusic
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextComponent(
                              text: state.selectedMusic!.title ?? '',
                              size: FontSizeConstants.NORMAL,
                              weight: FontWeight.w500,
                              tr: false,
                            ),
                            TextComponent(
                              text: state.selectedMusic!.artist ?? '',
                              size: FontSizeConstants.SMALL,
                              color: context.colors.onPrimary,
                              tr: false,
                            ),
                          ],
                        )
                      : TextComponent(
                          text: AppStrings.CREATE_POST_ADD_MUSIC,
                          size: FontSizeConstants.NORMAL,
                          weight: FontWeight.w600,
                        ),
                ),
                if (hasMusic) ...[
                  InkWell(
                    onTap: () {
                      context.read<PostUpdateCubit>().stopMusic();
                      context.read<PostUpdateCubit>().setSelectedMusic(null);
                    },
                    child: Icon(Icons.close, color: context.colors.onPrimary),
                  ),
                  SizedBox(width: context.width * .03),
                  InkWell(
                    onTap: () =>
                        context.read<PostUpdateCubit>().togglePlayPause(),
                    child: Icon(
                      state.isPlayingMusic
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: context.colors.primary,
                    ),
                  ),
                ] else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.onPrimary,
                    size: context.height * 0.015,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMusicBottomSheet(BuildContext context) {
    final cubit = context.read<PostUpdateCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: const _UpdateMusicBottomSheet(),
        );
      },
    ).then((result) {
      if (result is MusicModel) {
        cubit.stopMusic();
        cubit.setSelectedMusic(result);
      }
    });
  }
}

class _UpdateMusicBottomSheet extends StatefulWidget {
  const _UpdateMusicBottomSheet();

  @override
  State<_UpdateMusicBottomSheet> createState() =>
      _UpdateMusicBottomSheetState();
}

class _UpdateMusicBottomSheetState extends State<_UpdateMusicBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<MusicModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final results = await context.read<PostUpdateCubit>().searchSongs(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: EdgeInsets.only(bottom: keyboardInset),
          constraints: BoxConstraints(maxHeight: context.height * 0.5),
          decoration: BoxDecoration(
            color: context.colors.secondary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _handle(context),
              _title(context),
              _search(context),
              SizedBox(height: context.height * 0.02),
              _list(context),
            ],
          ),
        ),
      ),
    );
  }

  Container _handle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.height * 0.015),
      width: context.width * 0.12,
      height: 4,
      decoration: BoxDecoration(
        color: context.colors.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Padding _title(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.05,
        vertical: context.height * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextComponent(
            text: AppStrings.CREATE_POST_ADD_MUSIC,
            size: FontSizeConstants.X_LARGE,
            weight: FontWeight.w600,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: context.colors.primary),
          ),
        ],
      ),
    );
  }

  Padding _search(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_searchController.text == value) {
              _performSearch(value);
            }
          });
        },
        decoration: InputDecoration(
          hintText: AppStrings.CREATE_POST_SEARCH_MUSIC_PLACEHOLDER.tr(),
          hintStyle: TextStyle(color: context.colors.primaryContainer),
          prefixIcon: Icon(
            Icons.search,
            color: context.colors.primaryContainer,
          ),
          filled: true,
          fillColor: context.colors.onPrimaryFixed,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.width * 0.04,
            vertical: context.height * 0.015,
          ),
        ),
      ),
    );
  }

  Expanded _list(BuildContext context) {
    return Expanded(
      child: _isSearching
          ? Center(
              child: CircularProgressIndicator(color: context.colors.primary),
            )
          : _searchResults.isEmpty
          ? Center(
              child: TextComponent(
                text: _searchController.text.isEmpty
                    ? AppStrings.CREATE_POST_SEARCH_MUSIC.tr()
                    : AppStrings.CREATE_POST_NO_RESULTS.tr(),
                size: FontSizeConstants.NORMAL,
                color: context.colors.onSurface.withOpacity(0.6),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final music = _searchResults[index];
                return BlocBuilder<PostUpdateCubit, PostUpdateState>(
                  builder: (context, state) {
                    final isCurrentTrack =
                        state.currentPlayingMusicUrl == music.url;
                    final isPlayingCurrentTrack =
                        isCurrentTrack && state.isPlayingMusic;

                    return _song(context, music, isPlayingCurrentTrack);
                  },
                );
              },
            ),
    );
  }

  ListTile _song(
    BuildContext context,
    MusicModel music,
    bool isPlayingCurrentTrack,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.music_note,
        color: context.colors.primary,
        size: context.height * 0.05,
      ),
      title: TextComponent(
        text: music.title ?? '',
        size: FontSizeConstants.NORMAL,
        weight: FontWeight.w500,
        tr: false,
      ),
      subtitle: TextComponent(
        text: music.artist ?? '',
        size: FontSizeConstants.SMALL,
        color: context.colors.primaryContainer,
        tr: false,
      ),
      trailing: IconButton(
        onPressed: () {
          context.read<PostUpdateCubit>().toggleMusicPreview(music);
        },
        icon: Icon(
          isPlayingCurrentTrack
              ? Icons.pause_circle_filled
              : Icons.play_circle_fill,
          color: context.colors.primary,
        ),
      ),
      onTap: () => Navigator.pop(context, music),
    );
  }
}
