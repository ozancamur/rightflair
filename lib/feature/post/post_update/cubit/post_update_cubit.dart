import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/utils/dialogs/error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/face_blur.dart';
import '../../create_post/model/blur.dart';
import '../../create_post/model/mention_user.dart';
import '../../create_post/model/music.dart';
import '../../create_post/model/post.dart';
import '../model/update_post.dart';
import '../repository/post_update_repository.dart';

part 'post_update_state.dart';

class PostUpdateCubit extends Cubit<PostUpdateState> {
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final PostUpdateRepository _repo;
  PostUpdateCubit(this._repo) : super(const PostUpdateState()) {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      emit(this.state.copyWith(isPlayingMusic: state == PlayerState.playing));
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      emit(state.copyWith(isPlayingMusic: false));
    });
  }

  /// Initialize the cubit with existing post data
  void init({required PostModel post, required bool isDraft}) {
    MusicModel? music;
    if (post.musicAudioUrl != null && post.musicAudioUrl!.isNotEmpty) {
      music = MusicModel(
        title: post.musicTitle,
        artist: post.musicArtist,
        url: post.musicAudioUrl,
      );
    }

    emit(
      PostUpdateState(
        postId: post.id,
        postImageUrl: post.postImageUrl,
        description: post.description,
        isAnonymous: post.isAnonymous ?? false,
        allowComments: post.allowComments ?? true,
        selectedLocation: post.location,
        tags: post.tags ?? [],
        mentionedUserIds: post.mentionedUsers ?? [],
        selectedMusic: music,
        isDraft: isDraft,
      ),
    );
  }

  Future<void> toggleAnonymous(BuildContext context, bool value) async {
    if (state.originalImagePath != null) {
      emit(state.copyWith(isProcessingImage: true));
      final response = await _processImageWithBlur(
        state.originalImagePath!,
        isAnonymous: value,
      );
      if (response.isBlurred == false) {
        dialogError(
          context,
          message: AppStrings.CREATE_POST_FACE_DETECTION_FAILED.tr(),
        );
      }
      emit(
        state.copyWith(
          isAnonymous: response.isBlurred,
          imagePath: response.file.path,
          isProcessingImage: false,
        ),
      );
    } else {
      emit(state.copyWith(isAnonymous: value));
    }
  }

  Future<BlurModel> _processImageWithBlur(
    String imagePath, {
    required bool isAnonymous,
    int blurRadius = 100,
  }) async {
    if (!isAnonymous) {
      return BlurModel(file: File(imagePath), isBlurred: false);
    }

    final originalFile = File(imagePath);
    final blurredFile = await blurFacesInImage(
      originalFile,
      blurRadius: blurRadius,
    );
    return blurredFile;
  }

  void toggleAllowComments(bool value) =>
      emit(state.copyWith(allowComments: value));

  void updateLocation(String? location) =>
      emit(state.copyWith(selectedLocation: location));

  void addTag(String tag) {
    if (!state.tags.contains(tag)) {
      emit(state.copyWith(tags: [...state.tags, tag]));
    }
  }

  void removeTag(String tag) {
    final updatedTags = state.tags.where((t) => t != tag).toList();
    emit(state.copyWith(tags: updatedTags));
  }

  void addMention(String userId) {
    if (!state.mentionedUserIds.contains(userId)) {
      emit(
        state.copyWith(mentionedUserIds: [...state.mentionedUserIds, userId]),
      );
    }
  }

  void removeMention(String userId) {
    final updatedMentions = state.mentionedUserIds
        .where((id) => id != userId)
        .toList();
    emit(state.copyWith(mentionedUserIds: updatedMentions));
  }

  Future<List<MentionUserModel>> searchUsers(String query) async {
    if (query.isEmpty) return [];
    final users = await _repo.searchUsersForMention(query: query);
    return users ?? [];
  }

  Future<List<MusicModel>> searchSongs(String query) async {
    if (query.isEmpty) return [];
    final songs = await _repo.searchSong(query: query);
    return songs ?? [];
  }

  void setSelectedMusic(MusicModel? music) {
    if (music == null) {
      emit(
        PostUpdateState(
          isAnonymous: state.isAnonymous,
          allowComments: state.allowComments,
          selectedLocation: state.selectedLocation,
          selectedMusic: null,
          isPlayingMusic: state.isPlayingMusic,
          currentPlayingMusicUrl: state.currentPlayingMusicUrl,
          imagePath: state.imagePath,
          originalImagePath: state.originalImagePath,
          postImageUrl: state.postImageUrl,
          isProcessingImage: state.isProcessingImage,
          tags: state.tags,
          mentionedUserIds: state.mentionedUserIds,
          isLoading: state.isLoading,
          postId: state.postId,
          description: state.description,
          isDraft: state.isDraft,
        ),
      );
    } else {
      emit(state.copyWith(selectedMusic: music));
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      try {
        emit(state.copyWith(isProcessingImage: true));
        final response = await _processImageWithBlur(
          image.path,
          isAnonymous: state.isAnonymous,
        );
        emit(
          state.copyWith(
            imagePath: response.file.path,
            originalImagePath: image.path,
            isProcessingImage: false,
          ),
        );
      } catch (e) {
        debugPrint('Error processing gallery image: $e');
        emit(
          state.copyWith(
            imagePath: image.path,
            originalImagePath: image.path,
            isProcessingImage: false,
          ),
        );
      }
    }
  }

  Future<void> setImagePath(String path) async {
    emit(state.copyWith(isProcessingImage: true));
    final response = await _processImageWithBlur(
      path,
      isAnonymous: state.isAnonymous,
    );
    emit(
      state.copyWith(
        imagePath: response.file.path,
        originalImagePath: path,
        isProcessingImage: false,
      ),
    );
  }

  /// Upload the current image and return the public URL.
  Future<String?> _uploadImage() async {
    final String? uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || uid.isEmpty || state.imagePath == null) return null;
    try {
      final imageUrl = await _repo.uploadPostImage(
        userId: uid,
        file: File(state.imagePath!),
      );
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  /// Update draft (status stays the same)
  Future<void> updateDraft(
    BuildContext context, {
    String? description,
    List<String>? styleTags,
    List<String>? mentionedUserIds,
  }) async {
    await _updatePost(
      context,
      description: description,
      styleTags: styleTags,
      mentionedUserIds: mentionedUserIds,
      status: null, // keep current status
    );
  }

  /// Update and publish (status → published)
  Future<void> updateAndPublish(
    BuildContext context, {
    String? description,
    List<String>? styleTags,
    List<String>? mentionedUserIds,
  }) async {
    await _updatePost(
      context,
      description: description,
      styleTags: styleTags,
      mentionedUserIds: mentionedUserIds,
      status: 'published',
    );
  }

  Future<void> _updatePost(
    BuildContext context, {
    String? description,
    List<String>? styleTags,
    List<String>? mentionedUserIds,
    String? status,
  }) async {
    final String? uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || uid.isEmpty) {
      dialogError(context, message: AppStrings.ERROR_DEFAULT);
      return;
    }

    emit(state.copyWith(isLoading: true));

    // If draft and a new image was picked, upload it
    String? postImageUrl;
    if (state.isDraft) {
      postImageUrl = state.postImageUrl;
      if (state.imagePath != null) {
        final uploadedUrl = await _uploadImage();
        if (uploadedUrl != null) {
          postImageUrl = uploadedUrl;
        }
      }
    }

    final UpdatePostModel post = UpdatePostModel(
      postId: state.postId,
      postImageUrl: state.isDraft ? postImageUrl : null,
      description: description,
      location: state.selectedLocation,
      isAnonymous: state.isAnonymous,
      allowComments: state.allowComments,
      styleTags: styleTags ?? state.tags,
      mentionedUserIds: mentionedUserIds ?? state.mentionedUserIds,
      musicArtist: state.selectedMusic?.artist,
      musicTitle: state.selectedMusic?.title,
      musicAudioUrl: state.selectedMusic?.url,
      status: state.isDraft ? status : null,
    );

    final response = state.isDraft
        ? await _repo.updateDraft(post: post)
        : await _repo.updatePublishedPost(post: post);
    emit(state.copyWith(isLoading: false));

    if (response == null || response.success != true) {
      dialogError(
        context,
        message: response?.message ?? AppStrings.ERROR_DEFAULT,
      );
    } else {
      if (context.mounted) {
        context.pop('updated');
      }
    }
  }

  // ==================== Music Playback ====================

  Future<void> playMusic() async {
    if (state.selectedMusic != null) {
      final url = state.selectedMusic!.url;
      if (url == null || url.isEmpty) return;
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(UrlSource(url));
      emit(state.copyWith(currentPlayingMusicUrl: url));
    }
  }

  Future<void> pauseMusic() async {
    await _audioPlayer.pause();
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
    emit(state.copyWith(isPlayingMusic: false));
  }

  Future<void> togglePlayPause() async {
    if (state.isPlayingMusic) {
      await pauseMusic();
    } else {
      await playMusic();
    }
  }

  Future<void> toggleMusicPreview(MusicModel music) async {
    final url = music.url;
    if (url == null || url.isEmpty) return;

    final isSameTrack = state.currentPlayingMusicUrl == url;

    if (isSameTrack && state.isPlayingMusic) {
      await pauseMusic();
      return;
    }

    if (isSameTrack && !state.isPlayingMusic) {
      await _audioPlayer.resume();
      emit(state.copyWith(isPlayingMusic: true));
      return;
    }

    await _audioPlayer.play(UrlSource(url));
    emit(state.copyWith(currentPlayingMusicUrl: url, isPlayingMusic: true));
  }

  @override
  Future<void> close() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    return super.close();
  }
}
