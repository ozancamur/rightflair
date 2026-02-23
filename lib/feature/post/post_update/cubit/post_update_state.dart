part of 'post_update_cubit.dart';

class PostUpdateState {
  final bool isAnonymous;
  final bool allowComments;
  final String? selectedLocation;
  final MusicModel? selectedMusic;
  final bool isPlayingMusic;
  final String? currentPlayingMusicUrl;
  final String? imagePath;
  final String? originalImagePath;
  final String? postImageUrl;
  final bool isProcessingImage;
  final List<String> tags;
  final List<String> mentionedUserIds;
  final bool isLoading;
  final String? postId;
  final String? description;

  const PostUpdateState({
    this.isAnonymous = false,
    this.allowComments = true,
    this.selectedLocation,
    this.selectedMusic,
    this.isPlayingMusic = false,
    this.currentPlayingMusicUrl,
    this.imagePath,
    this.originalImagePath,
    this.postImageUrl,
    this.isProcessingImage = false,
    this.tags = const [],
    this.mentionedUserIds = const [],
    this.isLoading = false,
    this.postId,
    this.description,
  });

  PostUpdateState copyWith({
    bool? isAnonymous,
    bool? allowComments,
    String? selectedLocation,
    MusicModel? selectedMusic,
    bool? isPlayingMusic,
    String? currentPlayingMusicUrl,
    String? imagePath,
    String? originalImagePath,
    String? postImageUrl,
    bool? isProcessingImage,
    List<String>? tags,
    List<String>? mentionedUserIds,
    bool? isLoading,
    String? postId,
    String? description,
  }) {
    return PostUpdateState(
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowComments: allowComments ?? this.allowComments,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedMusic: selectedMusic ?? this.selectedMusic,
      isPlayingMusic: isPlayingMusic ?? this.isPlayingMusic,
      currentPlayingMusicUrl:
          currentPlayingMusicUrl ?? this.currentPlayingMusicUrl,
      imagePath: imagePath ?? this.imagePath,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      postImageUrl: postImageUrl ?? this.postImageUrl,
      isProcessingImage: isProcessingImage ?? this.isProcessingImage,
      tags: tags ?? this.tags,
      mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
      isLoading: isLoading ?? this.isLoading,
      postId: postId ?? this.postId,
      description: description ?? this.description,
    );
  }
}
