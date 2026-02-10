import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightflair/feature/post/create_post/model/create_post.dart';
import '../repository/create_post_repository.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final ImagePicker _picker = ImagePicker();

  final CreatePostRepository _repo;
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

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      emit(state.copyWith(imagePath: image.path));
    }
  }

  void setImagePath(String path) {
    emit(state.copyWith(imagePath: path));
  }

  Future<void> createPost({
    String? description,
    List<String>? styleTags,
    List<String>? mentionedUserIds,
  }) async {
    final CreatePostModel post = CreatePostModel(
      postImageUrl: state.imagePath,
      description: description,
      location: state.selectedLocation,
      isAnonymous: state.isAnonymous,
      allowComments: state.allowComments,
      styleTags: styleTags,
      mentionedUserIds: mentionedUserIds,
    );
    await _repo.createPost(post: post);
  }

  Future<void> createDraft({
    String? description,
    List<String>? styleTags,
    List<String>? mentionedUserIds,
  }) async {
    final CreatePostModel post = CreatePostModel(
      postImageUrl: state.imagePath,
      description: description,
      location: state.selectedLocation,
      isAnonymous: state.isAnonymous,
      allowComments: state.allowComments,
      styleTags: styleTags,
      mentionedUserIds: mentionedUserIds,
    );
    await _repo.createDraft(post: post);
  }
}
