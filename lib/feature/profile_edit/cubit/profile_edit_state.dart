part of 'profile_edit_cubit.dart';

class ProfileEditState extends Equatable {
  final String? name;
  final String? username;
  final String? bio;
  final List<String>? selectedStyles;
  final String? profileImage;
  final String? selectedImagePath;
  final bool isSaving;
  final bool isUploading;
  final String? errorMessage;

  const ProfileEditState({
    this.name,
    this.username,
    this.bio,
    this.selectedStyles,
    this.profileImage,
    this.selectedImagePath,
    this.isSaving = false,
    this.isUploading = false,
    this.errorMessage,
  });

  ProfileEditState copyWith({
    String? name,
    String? username,
    String? bio,
    List<String>? selectedStyles,
    String? profileImage,
    String? selectedImagePath,
    bool? isSaving,
    bool? isUploading,
    String? errorMessage,
  }) {
    return ProfileEditState(
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      selectedStyles: selectedStyles ?? this.selectedStyles,
      profileImage: profileImage ?? this.profileImage,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      isSaving: isSaving ?? this.isSaving,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    username,
    bio,
    selectedStyles,
    profileImage,
    selectedImagePath,
    isSaving,
    isUploading,
    errorMessage,
  ];
}


