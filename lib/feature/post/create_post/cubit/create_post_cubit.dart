import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../repository/create_post_repository.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostRepository _repo;
  final ImagePicker _picker = ImagePicker();

  CreatePostCubit(this._repo) : super(const CreatePostState());

  void toggleAnonymous(bool value) {
    emit(state.copyWith(isAnonymous: value));
  }

  void toggleAllowComments(bool value) {
    emit(state.copyWith(allowComments: value));
  }

  void updateLocation(String? location) {
    emit(state.copyWith(selectedLocation: location));
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (image != null) {
      emit(state.copyWith(imagePath: image.path));
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      emit(state.copyWith(imagePath: image.path));
    }
  }

  Future<void> createPost() async {
    await _repo.createPost();
  }
}
