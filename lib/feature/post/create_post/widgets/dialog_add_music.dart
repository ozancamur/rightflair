import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../cubit/create_post_cubit.dart';
import '../model/music.dart';

class AddMusicBottomSheet extends StatefulWidget {
  const AddMusicBottomSheet({super.key});

  @override
  State<AddMusicBottomSheet> createState() => _AddMusicBottomSheetState();
}

class _AddMusicBottomSheetState extends State<AddMusicBottomSheet> {
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

    final results = await context.read<CreatePostCubit>().searchSongs(query);

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
              // Handle bar
              _handle(context),

              // Title
              _title(context),

              // Search bar
              _search(context),

              SizedBox(height: context.height * 0.02),

              // Results
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
            text: 'Müzik Ekle',
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
          // Debounce ile search yapmak için
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_searchController.text == value) {
              _performSearch(value);
            }
          });
        },
        decoration: InputDecoration(
          hintText: 'Şarkı veya sanatçı ara...',
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
                    ? 'Müzik aramak için yukarıdaki alanı kullanın'
                    : 'Sonuç bulunamadı',
                size: FontSizeConstants.NORMAL,
                color: context.colors.onSurface.withOpacity(0.6),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final music = _searchResults[index];
                return BlocBuilder<CreatePostCubit, CreatePostState>(
                  builder: (context, state) {
                    final isCurrentTrack =
                        state.currentPlayingMusicUrl == music.url;
                    final isPlayingCurrentTrack =
                        isCurrentTrack && state.isPlayingMusic;

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
                      ),
                      subtitle: TextComponent(
                        text: music.artist ?? '',
                        size: FontSizeConstants.SMALL,
                        color: context.colors.primaryContainer,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          context.read<CreatePostCubit>().toggleMusicPreview(
                            music,
                          );
                        },
                        icon: Icon(
                          isPlayingCurrentTrack
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: context.colors.primary,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context, music);
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
