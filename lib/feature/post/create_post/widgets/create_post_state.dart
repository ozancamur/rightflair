part of '../cubit/create_post_cubit.dart';

class CreatePostState {
  final bool isAnonymous;
  final bool allowComments;
  final String? selectedLocation;
  final MusicModel? selectedMusic;
  final bool isPlayingMusic;
  final String? currentPlayingMusicUrl;
  final String? imagePath;
  final String? originalImagePath; 
  final bool isProcessingImage; 
  final List<String> tags;
  final List<String> mentionedUserIds;
  final bool isLoading;

  const CreatePostState({
    this.isAnonymous = false,
    this.allowComments = true,
    this.selectedLocation,
    this.selectedMusic,
    this.isPlayingMusic = false,
    this.currentPlayingMusicUrl,
    this.imagePath,
    this.originalImagePath,
    this.isProcessingImage = false,
    this.tags = const [],
    this.mentionedUserIds = const [],
    this.isLoading = false,
  });

  CreatePostState copyWith({
    bool? isAnonymous,
    bool? allowComments,
    String? selectedLocation,
    MusicModel? selectedMusic,
    bool? isPlayingMusic,
    String? currentPlayingMusicUrl,
    String? imagePath,
    String? originalImagePath,
    bool? isProcessingImage,
    List<String>? tags,
    List<String>? mentionedUserIds,
    bool? isLoading,
  }) {
    return CreatePostState(
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowComments: allowComments ?? this.allowComments,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedMusic: selectedMusic ?? this.selectedMusic,
      isPlayingMusic: isPlayingMusic ?? this.isPlayingMusic,
      currentPlayingMusicUrl:
          currentPlayingMusicUrl ?? this.currentPlayingMusicUrl,
      imagePath: imagePath ?? this.imagePath,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      isProcessingImage: isProcessingImage ?? this.isProcessingImage,
      tags: tags ?? this.tags,
      mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
