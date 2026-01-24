import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightflair/feature/navigation/page/profile/model/request_user_posts.dart';
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
  }

  Future<void> refresh() async {
    await _getUser();
    await _getUserStyleTags();
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

  Future<void> _getUserPosts() async {
    emit(state.copyWith(isPostsLoading: true));
    final response = await _repo.getUserPosts(
      parameters: RequestUserPostsModel().requestSortByDateOrderDesc(page: 1),
    );
    emit(
      state.copyWith(
        isPostsLoading: false,
        posts: response?.posts ?? [],
        postsPagination: response?.pagination,
      ),
    );
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
}
