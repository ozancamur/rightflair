import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightflair/feature/post/create_post/model/create_post.dart';
import '../model/mention_user.dart';
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
      styleTags: styleTags ?? state.tags,
      mentionedUserIds: mentionedUserIds ?? state.mentionedUserIds,
    );
    print("Creating post with data: ${post.toJson()}");
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
      styleTags: styleTags ?? state.tags,
      mentionedUserIds: mentionedUserIds ?? state.mentionedUserIds,
    );
    print("Creating draft with data: ${post.toJson()}");
  }
}
