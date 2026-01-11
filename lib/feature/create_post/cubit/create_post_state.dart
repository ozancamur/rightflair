part of 'create_post_cubit.dart';

class CreatePostState {
  final bool isAnonymous;
  final bool allowComments;
  final String? selectedLocation;

  const CreatePostState({
    this.isAnonymous = false,
    this.allowComments = true,
    this.selectedLocation,
  });

  CreatePostState copyWith({
    bool? isAnonymous,
    bool? allowComments,
    String? selectedLocation,
  }) {
    return CreatePostState(
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowComments: allowComments ?? this.allowComments,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}
