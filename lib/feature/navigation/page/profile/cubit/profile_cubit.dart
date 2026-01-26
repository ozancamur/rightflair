import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightflair/feature/navigation/page/profile/model/request_post.dart';
import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';
import 'package:rightflair/feature/navigation/page/profile/repository/profile_repository_impl.dart';

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

  Future<void> _getUser() async {
    emit(state.copyWith(isLoading: true));
    final UserModel? user = await _repo.getUser();
    emit(state.copyWith(isLoading: false, user: user ?? UserModel()));
  }

  Future<void> _getUserStyleTags() async {
    final response = await _repo.getUserStyleTags();
    emit(state.copyWith(tags: response));
  }

  Future<void> changePhotoDialog(BuildContext context, {String? userId}) async {
    if (userId == null) return;
    final option = await dialogPickImage(context);
    if (option == null || !context.mounted) return;

    switch (option) {
      case ImagePickerOption.camera:
        await _pickImageFromCamera(userId: userId);
        break;
      case ImagePickerOption.gallery:
        await _pickImageFromGallery(userId: userId);
        break;
    }
  }

  Future<void> _pickImageFromCamera({required String userId}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      await _uploadAndUpdateProfilePhoto(userId: userId, imagePath: image.path);
    }
  }

  Future<void> _pickImageFromGallery({required String userId}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      await _uploadAndUpdateProfilePhoto(userId: userId, imagePath: image.path);
    }
  }

  Future<void> _uploadAndUpdateProfilePhoto({
    required String userId,
    required String imagePath,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final File imageFile = File(imagePath);

      final String? photoUrl = await _repo.uploadProfilePhoto(
        userId: userId,
        imageFile: imageFile,
      );

      if (photoUrl != null) {
        await _repo.updateUser(profilePhotoUrl: photoUrl);
        final updatedUser = state.user.copyWith(profilePhotoUrl: photoUrl);
        emit(state.copyWith(isLoading: false, user: updatedUser));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      debugPrint("Error uploading photo: $e");
      emit(state.copyWith(isLoading: false));
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
