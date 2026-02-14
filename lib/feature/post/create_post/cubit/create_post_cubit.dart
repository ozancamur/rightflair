import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/utils/dialogs/error.dart';
import 'package:rightflair/feature/post/create_post/model/create_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/mention_user.dart';
import '../model/music.dart';
import '../repository/create_post_repository.dart';

part '../widgets/create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final CreatePostRepository _repo;
  CreatePostCubit(this._repo) : super(const CreatePostState()) {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      emit(this.state.copyWith(isPlayingMusic: state == PlayerState.playing));
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      emit(state.copyWith(isPlayingMusic: false));
    });
  }

  Future<void> toggleAnonymous(BuildContext context, bool value) async {
    if (state.originalImagePath != null) {
      emit(state.copyWith(isProcessingImage: true));
      emit(state.copyWith(isProcessingImage: false));
    }
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
    emit(state.copyWith(selectedMusic: music));
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      emit(state.copyWith(isProcessingImage: true));
      emit(
        state.copyWith(originalImagePath: image.path, isProcessingImage: false),
      );
    }
  }

  Future<void> setImagePath(String path) async {
    emit(state.copyWith(isProcessingImage: true));

    emit(state.copyWith(originalImagePath: path, isProcessingImage: false));
  }

  Future<void> createPost(
    BuildContext context, {
    String? description,
    List<String>? styleTags,
    List<String>? mentionedUserIds,
  }) async {
    final String? uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || uid == "") {
      dialogError(context, message: AppStrings.ERROR_DEFAULT);
      return;
    }
    emit(state.copyWith(isLoading: true));
    final String? postPhotoUrl = await _repo.uploadStoryImage(
      userId: uid,
      file: File(state.imagePath!),
    );
    if (postPhotoUrl == "" || postPhotoUrl == null) {
      dialogError(context, message: AppStrings.ERROR_DEFAULT);
      emit(state.copyWith(isLoading: false));
      return;
    }
    final CreatePostModel post = CreatePostModel(
      postImageUrl: postPhotoUrl,
      description: description,
      location: state.selectedLocation,
      isAnonymous: state.isAnonymous,
      allowComments: state.allowComments,
      styleTags: styleTags ?? state.tags,
      mentionedUserIds: mentionedUserIds ?? state.mentionedUserIds,
      musicArtist: state.selectedMusic?.artist,
      musicTitle: state.selectedMusic?.title,
      musicAudioUrl: state.selectedMusic?.url,
    );
    final response = await _repo.createPost(post: post);
    if (response == null || response.success != true) {
      dialogError(
        context,
        message: response?.message ?? AppStrings.ERROR_DEFAULT,
      );
    } else {
      context.go(RouteConstants.NAVIGATION);
    }
    emit(state.copyWith(isLoading: false));
  }

  Future<void> createDraft(
    BuildContext context, {
    String? description,
    List<String>? styleTags,
    List<String>? mentionedUserIds,
  }) async {
    final String? uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || uid == "") {
      dialogError(context, message: AppStrings.ERROR_DEFAULT);
      return;
    }
    emit(state.copyWith(isLoading: true));
    final String? postPhotoUrl = await _repo.uploadStoryImage(
      userId: uid,
      file: File(state.imagePath!),
    );
    if (postPhotoUrl == "" || postPhotoUrl == null) {
      dialogError(context, message: AppStrings.ERROR_DEFAULT);
      emit(state.copyWith(isLoading: false));
      return;
    }
    final CreatePostModel post = CreatePostModel(
      postImageUrl: postPhotoUrl,
      description: description,
      location: state.selectedLocation,
      isAnonymous: state.isAnonymous,
      allowComments: state.allowComments,
      styleTags: styleTags ?? state.tags,
      mentionedUserIds: mentionedUserIds ?? state.mentionedUserIds,
      musicArtist: state.selectedMusic?.artist,
      musicTitle: state.selectedMusic?.title,
      musicAudioUrl: state.selectedMusic?.url,
    );
    final response = await _repo.createDraft(post: post);
    if (response == null || response.success != true) {
      dialogError(
        context,
        message: response?.message ?? AppStrings.ERROR_DEFAULT,
      );
    } else {
      context.go(RouteConstants.NAVIGATION);
    }
  }

  Future<void> playMusic() async {
    if (state.selectedMusic != null) {
      final url = state.selectedMusic!.url;
      if (url == null || url.isEmpty) return;
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
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
