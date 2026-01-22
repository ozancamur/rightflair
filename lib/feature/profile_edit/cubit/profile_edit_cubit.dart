import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/dialog.dart';
import '../../authentication/model/user.dart';
import '../repository/profile_edit_repository.dart';

part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  final ProfileEditRepository _repo;
  final ImagePicker _picker = ImagePicker();

  ProfileEditCubit(this._repo) : super(const ProfileEditState());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updateBio(String bio) {
    emit(state.copyWith(bio: bio));
  }

  void updateProfileImage(String imageUrl) {
    emit(state.copyWith(profileImage: imageUrl));
  }

  Future<void> changePhotoDialog(BuildContext context, {String? userId}) async {
    if (userId == null) return;
    final option = await DialogUtils.showImagePickerDialog(context);
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
    emit(state.copyWith(isUploading: true));
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      emit(state.copyWith(selectedImagePath: image.path));
      await _uploadAndUpdateProfilePhoto(userId: userId, imagePath: image.path);
    }
    emit(state.copyWith(isUploading: false));
  }

  Future<void> _pickImageFromGallery({required String userId}) async {
    emit(state.copyWith(isUploading: true));
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      emit(state.copyWith(selectedImagePath: image.path));
      await _uploadAndUpdateProfilePhoto(userId: userId, imagePath: image.path);
    }
    emit(state.copyWith(isUploading: false));
  }

  Future<void> _uploadAndUpdateProfilePhoto({
    required String userId,
    required String imagePath,
  }) async {
    if (!isClosed) emit(state.copyWith(isUploading: true, errorMessage: null));
    try {
      final File imageFile = File(imagePath);

      final String? photoUrl = await _repo.uploadProfilePhoto(
        userId: userId,
        imageFile: imageFile,
      );

      if (photoUrl != null) {
        await _repo.updateUser(profilePhotoUrl: photoUrl);
        if (!isClosed) {
          emit(state.copyWith(profileImage: photoUrl, isUploading: false));
        }
      } else {
        if (!isClosed) {
          emit(
            state.copyWith(
              isUploading: false,
              errorMessage: 'Fotoğraf yüklenemedi',
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isUploading: false,
            errorMessage: 'Fotoğraf yüklenirken hata oluştu: $e',
          ),
        );
      }
    }
  }

  Future<void> addStyle(String style) async {
    final styles = state.selectedStyles ?? [];
    if (styles.length < 3 && !styles.contains(style)) {
      final updatedStyles = List<String>.from(styles)..add(style);
      await _repo.updateUserStyleTags(tags: updatedStyles);
      emit(state.copyWith(selectedStyles: updatedStyles));
    }
  }

  Future<void> removeStyle(String style) async {
    final updatedStyles = List<String>.from(state.selectedStyles ?? [])
      ..remove(style);
    await _repo.updateUserStyleTags(tags: updatedStyles);
    emit(state.copyWith(selectedStyles: updatedStyles));
  }

  Future<void> saveProfile(UserModel user) async {
    final bool nameChanged = (state.name ?? '') != (user.fullName ?? '');
    final bool bioChanged = (state.bio ?? '') != (user.bio ?? '');

    if (nameChanged || bioChanged) {
      if (!isClosed) emit(state.copyWith(isSaving: true, errorMessage: null));
      try {
        await _repo.updateUser(
          fullName: nameChanged ? (state.name ?? '') : null,
          bio: bioChanged ? (state.bio ?? '') : null,
        );
        if (!isClosed) emit(state.copyWith(isSaving: false));
      } catch (e) {
        if (!isClosed) {
          emit(
            state.copyWith(
              isSaving: false,
              errorMessage: 'Profil kaydedilemedi: $e',
            ),
          );
        }
      }
    }
  }

  bool get canAddMoreStyles => (state.selectedStyles?.length ?? 0) < 3;
  int get remainingStyleSlots => 3 - (state.selectedStyles?.length ?? 0);
}
