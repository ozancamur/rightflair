part of 'create_post_cubit.dart';

class CreatePostState {
  final bool isAnonymous;
  final bool allowComments;
  final String? selectedLocation;
  final String? imagePath;

  const CreatePostState({
    this.isAnonymous = false,
    this.allowComments = true,
    this.selectedLocation,
    this.imagePath,
  });

  CreatePostState copyWith({
    bool? isAnonymous,
    bool? allowComments,
    String? selectedLocation,
    String? imagePath,
  }) {
    return CreatePostState(
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowComments: allowComments ?? this.allowComments,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
