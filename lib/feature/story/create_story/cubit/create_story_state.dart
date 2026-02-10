part of 'create_story_cubit.dart';

class CreateStoryState extends Equatable {
  final bool? isLoading;
  final bool? uploadSuccess;
  final String? error;

  const CreateStoryState({
    required this.isLoading,
    this.uploadSuccess,
    this.error,
  });

  CreateStoryState copyWith({
    bool? isLoading,
    bool? uploadSuccess,
    String? error,
  }) {
    return CreateStoryState(
      isLoading: isLoading ?? this.isLoading,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading ?? false, uploadSuccess, error];
}
