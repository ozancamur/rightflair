part of 'create_story_cubit.dart';

class CreateStoryState extends Equatable {
  final bool? isLoading;
  final bool? uploadSuccess;
  final String? error;
  final String? uploadedMediaUrl;
  final String? mediaType;
  final int? duration;

  const CreateStoryState({
    required this.isLoading,
    this.uploadSuccess,
    this.error,
    this.uploadedMediaUrl,
    this.mediaType,
    this.duration,
  });

  CreateStoryState copyWith({
    bool? isLoading,
    bool? uploadSuccess,
    String? error,
    String? uploadedMediaUrl,
    String? mediaType,
    int? duration,
  }) {
    return CreateStoryState(
      isLoading: isLoading ?? this.isLoading,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
      error: error ?? this.error,
      uploadedMediaUrl: uploadedMediaUrl ?? this.uploadedMediaUrl,
      mediaType: mediaType ?? this.mediaType,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [
    isLoading ?? false,
    uploadSuccess,
    error,
    uploadedMediaUrl,
    mediaType,
    duration,
  ];
}
