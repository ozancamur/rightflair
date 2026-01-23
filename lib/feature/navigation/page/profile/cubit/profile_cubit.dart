import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';
import 'package:rightflair/feature/navigation/page/profile/repository/profile_repository_impl.dart';

import '../../../../../core/utils/dialogs/pick_image.dart';
import '../../../../authentication/model/user.dart';
import '../model/photo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepositoryImpl _repo;
  final ImagePicker _picker = ImagePicker();

  ProfileCubit(this._repo)
    : super(
        ProfileState(
          user: UserModel(),
          isLoading: false,
          photos: [
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1657460312/tr/foto%C4%9Fraf/beautiful-sensual-woman.jpg?s=1024x1024&w=is&k=20&c=mpNuQR920Mv2wZoFr-J13OOjS_rjcNNVZmusAvqMYV8=',
              viewed: 1242,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1362588255/tr/foto%C4%9Fraf/beautiful-brunette-woman-walking-on-sunset-beach-in-fashionable-maxi-dress-relaxing-on.jpg?s=1024x1024&w=is&k=20&c=hKza9LJ80QTYijNY1kMKKuRjhA6J00-1x8gh943g0gc=',

              viewed: 432,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1311415818/tr/foto%C4%9Fraf/giyindim-ve-hayallerimin-pe%C5%9Finden-gitmeye-haz%C4%B1r.jpg?s=1024x1024&w=is&k=20&c=UMSoGayVya20IjU0AKsGNs1EnFf_HKZ7pX-B5_MliM0=',
              viewed: 521,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1462655622/tr/foto%C4%9Fraf/beautiful-woman-in-a-leather-suit-looking-masculine.jpg?s=1024x1024&w=is&k=20&c=z3rSRE4jNYtQ0lD2Lzn0_idWA-o9SElixR-qwY3M4Ss=',
              viewed: 1,
            ),
          ],
          isPhotosLoading: false,
          saves: [
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1462655622/tr/foto%C4%9Fraf/beautiful-woman-in-a-leather-suit-looking-masculine.jpg?s=1024x1024&w=is&k=20&c=z3rSRE4jNYtQ0lD2Lzn0_idWA-o9SElixR-qwY3M4Ss=',
              viewed: 521,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1362588255/tr/foto%C4%9Fraf/beautiful-brunette-woman-walking-on-sunset-beach-in-fashionable-maxi-dress-relaxing-on.jpg?s=1024x1024&w=is&k=20&c=hKza9LJ80QTYijNY1kMKKuRjhA6J00-1x8gh943g0gc=',

              viewed: 3251,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1657460312/tr/foto%C4%9Fraf/beautiful-sensual-woman.jpg?s=1024x1024&w=is&k=20&c=mpNuQR920Mv2wZoFr-J13OOjS_rjcNNVZmusAvqMYV8=',
              viewed: 42,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1311415818/tr/foto%C4%9Fraf/giyindim-ve-hayallerimin-pe%C5%9Finden-gitmeye-haz%C4%B1r.jpg?s=1024x1024&w=is&k=20&c=UMSoGayVya20IjU0AKsGNs1EnFf_HKZ7pX-B5_MliM0=',
              viewed: 126,
            ),
          ],
          isSavesLoading: false,
          drafts: [
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1657460312/tr/foto%C4%9Fraf/beautiful-sensual-woman.jpg?s=1024x1024&w=is&k=20&c=mpNuQR920Mv2wZoFr-J13OOjS_rjcNNVZmusAvqMYV8=',
              viewed: 425,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1462655622/tr/foto%C4%9Fraf/beautiful-woman-in-a-leather-suit-looking-masculine.jpg?s=1024x1024&w=is&k=20&c=z3rSRE4jNYtQ0lD2Lzn0_idWA-o9SElixR-qwY3M4Ss=',
              viewed: 645,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1311415818/tr/foto%C4%9Fraf/giyindim-ve-hayallerimin-pe%C5%9Finden-gitmeye-haz%C4%B1r.jpg?s=1024x1024&w=is&k=20&c=UMSoGayVya20IjU0AKsGNs1EnFf_HKZ7pX-B5_MliM0=',
              viewed: 14215,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1362588255/tr/foto%C4%9Fraf/beautiful-brunette-woman-walking-on-sunset-beach-in-fashionable-maxi-dress-relaxing-on.jpg?s=1024x1024&w=is&k=20&c=hKza9LJ80QTYijNY1kMKKuRjhA6J00-1x8gh943g0gc=',

              viewed: 2,
            ),
          ],
          isDraftsLoading: false,
        ),
      ) {
    _getUser();
    _getUserStyleTags();
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
