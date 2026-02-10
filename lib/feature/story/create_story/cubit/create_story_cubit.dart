import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightflair/feature/story/create_story/repository/create_story_repository_impl.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/enums/media_picker_option.dart';
import '../../../../core/constants/string.dart';
import '../../../main/feed/bloc/feed_bloc.dart';
import '../model/create_story.dart';

part 'create_story_state.dart';

class CreateStoryCubit extends Cubit<CreateStoryState> {
  final CreateStoryRepositoryImpl _repo;
  CreateStoryCubit(this._repo) : super(CreateStoryState(isLoading: false));
  final ImagePicker _picker = ImagePicker();

  Future<void> select(
    BuildContext context, {
    String? uid,
    required MediaPickerOption option,
  }) => _pick(context, option: option, uid: uid);

  Future<void> _pick(
    BuildContext context, {
    String? uid,
    required MediaPickerOption option,
  }) async {
    if (uid == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      final XFile? pickedFile = await _picker.pickMedia(imageQuality: 85);

      if (pickedFile == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final File mediaFile = File(pickedFile.path);

      final String extension = pickedFile.path.split('.').last.toLowerCase();
      final bool isVideo = [
        'mp4',
        'mov',
        'avi',
        'mkv',
        'flv',
        'wmv',
        'webm',
      ].contains(extension);
      final String mediaType = isVideo ? 'video' : 'image';

      // Storage'e yükle
      final String? mediaUrl = await _repo.uploadStoryImage(
        userId: uid,
        file: mediaFile,
      );

      if (mediaUrl == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      // Duration hesapla
      int duration = 10; // Default fotoğraf için 10 saniye
      if (isVideo) {
        duration = await _getVideoDuration(pickedFile.path);
      }

      // Story oluştur
      await createStory(
        context,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        duration: duration,
      );

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      debugPrint("Error in dialogCreateStory: $e");
      emit(state.copyWith(isLoading: false));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.PROFILE_EDIT_STORY_CREATED_ERROR.tr()),
          ),
        );
      }
    }
  }

  Future<int> _getVideoDuration(String videoPath) async {
    try {
      final VideoPlayerController controller = VideoPlayerController.file(
        File(videoPath),
      );
      await controller.initialize();
      final duration = controller.value.duration.inSeconds;
      await controller.dispose();
      return duration;
    } catch (e) {
      debugPrint("Error getting video duration: $e");
      return 10; // Hata durumunda default 10 saniye
    }
  }

  Future<void> createStory(
    BuildContext context, {
    required String mediaUrl,
    required String mediaType,
    required int duration,
  }) async {
    try {
      final CreateStoryModel data = CreateStoryModel(
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        duration: duration,
      );

      await _repo.createStory(data: data);

      // Refresh stories after story is created
      if (context.mounted) {
        try {
          context.read<FeedBloc>().add(FeedRefreshStoryEvent());
        } catch (e) {
          debugPrint("Could not refresh stories: $e");
        }
      }
    } catch (e) {
      debugPrint("ProfileCubit ERROR in createStory :> $e");
      rethrow;
    }
  }

  Future<void> uploadStoryMedia({
    required BuildContext context,
    required String uid,
    required File mediaFile,
    required bool isVideo,
  }) async {
    emit(state.copyWith(isLoading: true, uploadSuccess: false, error: null));

    try {
      // Medya türünü belirle
      final String mediaType = isVideo ? 'video' : 'image';

      // Storage'e yükle
      final String? mediaUrl = await _repo.uploadStoryImage(
        userId: uid,
        file: mediaFile,
      );

      if (mediaUrl == null) {
        emit(
          state.copyWith(
            isLoading: false,
            error: AppStrings.PROFILE_EDIT_STORY_CREATED_ERROR.tr(),
          ),
        );
        return;
      }

      // Duration hesapla
      int duration = 10; // Default fotoğraf için 10 saniye
      if (isVideo) {
        duration = await _getVideoDuration(mediaFile.path);
      }

      // Story oluştur
      await createStory(
        context,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        duration: duration,
      );

      emit(state.copyWith(isLoading: false, uploadSuccess: true));
    } catch (e) {
      debugPrint("Error in uploadStoryMedia: $e");
      emit(
        state.copyWith(
          isLoading: false,
          error: AppStrings.PROFILE_EDIT_STORY_CREATED_ERROR.tr(),
        ),
      );
    }
  }
}
