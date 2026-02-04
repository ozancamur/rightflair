import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:rightflair/feature/navigation/page/profile/model/create_story.dart';
import 'package:rightflair/feature/navigation/page/profile/model/request_post.dart';
import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';
import 'package:rightflair/feature/navigation/page/profile/repository/profile_repository_impl.dart';

import '../../../../../core/constants/string.dart';
import '../../../../../core/utils/dialogs/pick_image.dart';
import '../../../../authentication/model/user.dart';
import '../../../../create_post/model/post.dart';
import '../model/pagination.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepositoryImpl _repo;
  final ImagePicker _picker = ImagePicker();

  ProfileCubit(this._repo)
    : super(
        ProfileState(
          user: UserModel(),
          isLoading: false,
          posts: [],
          isPostsLoading: false,
          saves: [],
          isSavesLoading: false,
          drafts: [],
          isDraftsLoading: false,
        ),
      ) {
    _getUser();
    _getUserStyleTags();
    _getUserPosts();
    _getUserSavedPosts();
    _getUserDrafts();
  }

  Future<void> refresh() async {
    await _getUser();
    await _getUserStyleTags();
    await _getUserPosts();
    await _getUserSavedPosts();
    await _getUserDrafts();
  }

  Future<void> deleteRefresh() async {
    await _getUserPosts();
    await _getUserSavedPosts();
    await _getUserDrafts();
  }

  Future<void> _getUser() async {
    emit(state.copyWith(isLoading: true));
    final UserModel? user = await _repo.getUser();
    emit(state.copyWith(isLoading: false, user: user ?? UserModel()));
  }

  Future<void> _getUserStyleTags() async {
    final response = await _repo.getUserStyleTags();
    emit(state.copyWith(tags: response));
  }

  // STORY

  Future<void> dialogCreateStory(BuildContext context, {String? userId}) async {
    if (userId == null) return;

    final source = await dialogPickMedia(context);
    if (source == null || !context.mounted) return;

    emit(state.copyWith(isLoading: true));

    try {
      // Kullanıcıya hem fotoğraf hem video seçme imkanı sunuyoruz
      final XFile? pickedFile = await _picker.pickMedia(imageQuality: 85);

      if (pickedFile == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final File mediaFile = File(pickedFile.path);

      // Dosya uzantısından media type'ı belirle
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
      final String mediaType = isVideo ? 'video' : 'photo';

      // Storage'e yükle
      final String? mediaUrl = await _repo.uploadStoryImage(
        userId: userId,
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
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        duration: duration,
      );

      emit(state.copyWith(isLoading: false));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.PROFILE_EDIT_STORY_CREATED_SUCCESS.tr()),
          ),
        );
      }
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

  Future<void> createStory({
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
    } catch (e) {
      debugPrint("ProfileCubit ERROR in createStory :> $e");
      rethrow;
    }
  }

  // POSTS
  Future<void> _getUserPosts() async {
    emit(state.copyWith(isPostsLoading: true));
    final response = await _repo.getUserPosts(
      parameters: RequestPostModel().requestSortByDateOrderDesc(page: 1),
    );
    emit(
      state.copyWith(
        isPostsLoading: false,
        posts: response?.posts ?? [],
        postsPagination: response?.pagination,
      ),
    );
  }

  Future<void> loadMorePosts() async {
    if (state.isPostsLoading || state.isLoadingMorePosts) return;
    if (state.postsPagination?.hasNext != true) return;

    emit(state.copyWith(isLoadingMorePosts: true));

    final nextPage = (state.postsPagination?.page ?? 1) + 1;
    final response = await _repo.getUserPosts(
      parameters: RequestPostModel().requestSortByDateOrderDesc(page: nextPage),
    );

    if (response?.posts != null) {
      final currentPosts = List<PostModel>.from(state.posts ?? []);
      currentPosts.addAll(response!.posts!);

      emit(
        state.copyWith(
          posts: currentPosts,
          postsPagination: response.pagination,
          isLoadingMorePosts: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMorePosts: false));
    }
  }

  // SAVES
  Future<void> _getUserSavedPosts() async {
    emit(state.copyWith(isSavesLoading: true));
    final response = await _repo.getUserSavedPosts(
      parameters: RequestPostModel().requestSortByDateOrderDesc(page: 1),
    );
    emit(
      state.copyWith(
        isSavesLoading: false,
        saves: response?.posts ?? [],
        savesPagination: response?.pagination,
      ),
    );
  }

  Future<void> loadMoreSaves() async {
    if (state.isSavesLoading || state.isLoadingMoreSaves) return;
    if (state.savesPagination?.hasNext != true) return;

    emit(state.copyWith(isLoadingMoreSaves: true));

    final nextPage = (state.savesPagination?.page ?? 1) + 1;
    final response = await _repo.getUserSavedPosts(
      parameters: RequestPostModel().requestSortByDateOrderDesc(page: nextPage),
    );

    if (response?.posts != null) {
      final currentSaves = List<PostModel>.from(state.saves ?? []);
      currentSaves.addAll(response!.posts!);

      emit(
        state.copyWith(
          saves: currentSaves,
          savesPagination: response.pagination,
          isLoadingMoreSaves: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMoreSaves: false));
    }
  }

  // DRAFTS
  Future<void> _getUserDrafts() async {
    emit(state.copyWith(isDraftsLoading: true));
    final response = await _repo.getUserDrafts(
      parameters: RequestPostModel().requestSortByDateOrderDesc(page: 1),
    );
    emit(
      state.copyWith(
        isDraftsLoading: false,
        drafts: response?.posts ?? [],
        draftsPagination: response?.pagination,
      ),
    );
  }

  Future<void> loadMoreDrafts() async {
    if (state.isDraftsLoading || state.isLoadingMoreDrafts) return;
    if (state.draftsPagination?.hasNext != true) return;
    emit(state.copyWith(isLoadingMoreDrafts: true));

    final nextPage = (state.draftsPagination?.page ?? 1) + 1;
    final response = await _repo.getUserDrafts(
      parameters: RequestPostModel().requestSortByDateOrderDesc(page: nextPage),
    );

    if (response?.posts != null) {
      final currentPosts = List<PostModel>.from(state.drafts ?? []);
      currentPosts.addAll(response!.posts!);

      emit(
        state.copyWith(
          drafts: currentPosts,
          draftsPagination: response.pagination,
          isLoadingMoreDrafts: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMoreDrafts: false));
    }
  }
}
