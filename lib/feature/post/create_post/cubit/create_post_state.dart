part of 'create_post_cubit.dart';

class CreatePostState {
  final bool isAnonymous;
  final bool allowComments;
  final String? selectedLocation;
  final String? imagePath;
  final List<String> tags;
  final List<String> mentionedUserIds;

  const CreatePostState({
    this.isAnonymous = false,
    this.allowComments = true,
    this.selectedLocation,
    this.imagePath,
    this.tags = const [],
    this.mentionedUserIds = const [],
  });

  CreatePostState copyWith({
    bool? isAnonymous,
    bool? allowComments,
    String? selectedLocation,
    String? imagePath,
    List<String>? tags,
    List<String>? mentionedUserIds,
  }) {
    return CreatePostState(
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowComments: allowComments ?? this.allowComments,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      imagePath: imagePath ?? this.imagePath,
      tags: tags ?? this.tags,
      mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
    );
  }
}
