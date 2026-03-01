import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/services/cache.dart';
import 'package:rightflair/core/utils/dialogs/error.dart';
import 'package:rightflair/feature/post/create_post/model/create_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/face_blur.dart';
import '../model/blur.dart';
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
        CreatePostState(
          isAnonymous: state.isAnonymous,
          allowComments: state.allowComments,
          selectedLocation: state.selectedLocation,
          selectedMusic: null,
          isPlayingMusic: state.isPlayingMusic,
          currentPlayingMusicUrl: state.currentPlayingMusicUrl,
          imagePath: state.imagePath,
          originalImagePath: state.originalImagePath,
          isProcessingImage: state.isProcessingImage,
          tags: state.tags,
          mentionedUserIds: state.mentionedUserIds,
          isLoading: state.isLoading,
          pendingDescription: state.pendingDescription,
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
        // Proactively save pending post
        await savePendingPost();
      } catch (e) {
        debugPrint('Error processing gallery image: $e');
        emit(
          state.copyWith(
            imagePath: image.path,
            originalImagePath: image.path,
            isProcessingImage: false,
          ),
        );
        // Proactively save pending post
        await savePendingPost();
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
    // Proactively save pending post as soon as image is set
    // This ensures data is persisted even if lifecycle events don't complete
    await savePendingPost();
  }

  /// Upload the current image and return the public URL.
  Future<String?> uploadImage() async {
    final String? uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || uid.isEmpty || state.imagePath == null) return null;
    try {
      final imageUrl = await _repo.uploadStoryImage(
        userId: uid,
        file: File(state.imagePath!),
      );
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
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
    // Clear cache as soon as post is initiated
    await clearPendingPost();
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
      await CacheService().setHasPublishedPost(true);
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
    // Clear cache as soon as draft is initiated
    await clearPendingPost();
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

  // ==================== Pending Post (Continue Editing) ====================

  final CacheService _cacheService = CacheService();

  /// Save current post state to cache (called on app lifecycle pause)
  Future<void> savePendingPost({String? description}) async {
    debugPrint(
      '[ContinueEditing] savePendingPost() called, imagePath=${state.imagePath}, description=$description',
    );
    if (state.imagePath == null) {
      debugPrint(
        '[ContinueEditing] savePendingPost: imagePath is null, skipping',
      );
      return;
    }
    debugPrint(
      '[ContinueEditing] savePendingPost: saving with imagePath=${state.imagePath}',
    );

    try {
      // 1. Save to SharedPreferences IMMEDIATELY with current paths
      //    This must happen first — app may be killed any moment
      final data = <String, dynamic>{
        'imagePath': state.imagePath,
        'originalImagePath': state.originalImagePath,
        'description': description ?? '',
        'isAnonymous': state.isAnonymous,
        'allowComments': state.allowComments,
        'selectedLocation': state.selectedLocation,
        'tags': state.tags,
        'mentionedUserIds': state.mentionedUserIds,
        if (state.selectedMusic != null) ...{
          'musicTitle': state.selectedMusic!.title,
          'musicArtist': state.selectedMusic!.artist,
          'musicUrl': state.selectedMusic!.url,
        },
      };
      await _cacheService.savePendingPost(data);
      debugPrint(
        '[ContinueEditing] savePendingPost: step 1 done (SharedPreferences saved)',
      );

      // 2. Copy images to persistent directory (best-effort, may not complete)
      final appDir = await getApplicationDocumentsDirectory();
      debugPrint('[ContinueEditing] savePendingPost: appDir=${appDir.path}');
      final pendingDir = Directory('${appDir.path}/pending_post');
      if (!await pendingDir.exists()) {
        await pendingDir.create(recursive: true);
      }

      String? persistentImagePath;
      String? persistentOriginalPath;

      final imageFile = File(state.imagePath!);
      debugPrint(
        '[ContinueEditing] savePendingPost: imageFile exists=${await imageFile.exists()}',
      );
      if (await imageFile.exists()) {
        final ext = state.imagePath!.split('.').last;
        final dest = File('${pendingDir.path}/pending_image.$ext');
        await imageFile.copy(dest.path);
        persistentImagePath = dest.path;
        debugPrint(
          '[ContinueEditing] savePendingPost: image copied to $persistentImagePath',
        );
      }

      if (state.originalImagePath != null) {
        final origFile = File(state.originalImagePath!);
        if (await origFile.exists()) {
          final ext = state.originalImagePath!.split('.').last;
          final dest = File('${pendingDir.path}/pending_original.$ext');
          await origFile.copy(dest.path);
          persistentOriginalPath = dest.path;
          debugPrint(
            '[ContinueEditing] savePendingPost: original copied to $persistentOriginalPath',
          );
        }
      }

      // 3. Update SharedPreferences with RELATIVE paths
      //    iOS can change sandbox UUID between launches, so absolute paths break.
      //    We save relative-to-Documents paths and reconstruct on restore.
      if (persistentImagePath != null || persistentOriginalPath != null) {
        final docsPath = appDir.path;
        if (persistentImagePath != null) {
          data['imagePath'] = persistentImagePath.replaceFirst(
            '$docsPath/',
            '',
          );
        }
        if (persistentOriginalPath != null) {
          data['originalImagePath'] = persistentOriginalPath.replaceFirst(
            '$docsPath/',
            '',
          );
        }
        await _cacheService.savePendingPost(data);
        debugPrint(
          '[ContinueEditing] savePendingPost: step 3 done (relative paths saved: image=${data['imagePath']}, original=${data['originalImagePath']})',
        );
      }
      debugPrint('[ContinueEditing] savePendingPost: COMPLETE');
    } catch (e, stackTrace) {
      debugPrint('[ContinueEditing] savePendingPost: ERROR $e');
      debugPrint('[ContinueEditing] StackTrace: $stackTrace');
    }
  }

  /// Resolve a cached path to an absolute path.
  /// If the path is relative (e.g. "pending_post/pending_image.png"),
  /// prepend the current Documents directory.
  Future<String?> _resolveImagePath(String? path) async {
    if (path == null) return null;
    // Already absolute
    if (path.startsWith('/')) {
      if (File(path).existsSync()) return path;
      // Absolute but file missing — try to reconstruct from filename
      final filename = path.split('/').last;
      final appDir = await getApplicationDocumentsDirectory();
      final reconstructed = '${appDir.path}/pending_post/$filename';
      if (File(reconstructed).existsSync()) return reconstructed;
      return null;
    }
    // Relative path
    final appDir = await getApplicationDocumentsDirectory();
    final absolute = '${appDir.path}/$path';
    if (File(absolute).existsSync()) return absolute;
    return null;
  }

  /// Restore post state from cache
  Future<void> restorePendingPost() async {
    final data = await _cacheService.getPendingPost();
    if (data == null) return;

    MusicModel? music;
    if (data['musicTitle'] != null) {
      music = MusicModel(
        title: data['musicTitle'] as String?,
        artist: data['musicArtist'] as String?,
        url: data['musicUrl'] as String?,
      );
    }

    // Resolve paths (handles both relative and stale absolute paths)
    final restoredImagePath = await _resolveImagePath(
      data['imagePath'] as String?,
    );
    final restoredOriginalPath = await _resolveImagePath(
      data['originalImagePath'] as String?,
    );

    debugPrint(
      '[ContinueEditing] restorePendingPost: resolved imagePath=$restoredImagePath',
    );
    debugPrint(
      '[ContinueEditing] restorePendingPost: resolved originalPath=$restoredOriginalPath',
    );

    emit(
      CreatePostState(
        imagePath: restoredImagePath,
        originalImagePath: restoredOriginalPath,
        isAnonymous: data['isAnonymous'] as bool? ?? false,
        allowComments: data['allowComments'] as bool? ?? true,
        selectedLocation: data['selectedLocation'] as String?,
        tags:
            (data['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        mentionedUserIds:
            (data['mentionedUserIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        selectedMusic: music,
        pendingDescription: data['description'] as String?,
      ),
    );
    debugPrint(
      '[ContinueEditing] restorePendingPost: emitted state, imagePath=${state.imagePath}',
    );

    // Clear cache after restoring — only SharedPreferences, files remain
    await _cacheService.clearPendingPost();
    debugPrint(
      '[ContinueEditing] restorePendingPost: cache cleared, state.imagePath=${state.imagePath}',
    );
  }

  /// Get pending post description from cache (for restoring TextField)
  Future<String?> getPendingPostDescription() async {
    final data = await _cacheService.getPendingPost();
    if (data == null) return null;
    return data['description'] as String?;
  }

  /// Check if there is a pending post to continue editing
  Future<Map<String, dynamic>?> getPendingPostData() async {
    return await _cacheService.getPendingPost();
  }

  /// Clear pending post cache and delete persistent image files
  Future<void> clearPendingPost() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final pendingDir = Directory('${appDir.path}/pending_post');
      if (await pendingDir.exists()) {
        await pendingDir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Error deleting pending post files: $e');
    }
    await _cacheService.clearPendingPost();
  }

  @override
  Future<void> close() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    return super.close();
  }
}
