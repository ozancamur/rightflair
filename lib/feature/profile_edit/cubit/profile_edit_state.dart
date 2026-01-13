part of 'profile_edit_cubit.dart';

class ProfileEditState extends Equatable {
  final String name;
  final String username;
  final String bio;
  final List<String> selectedStyles;
  final String profileImage;
  final bool isSaving;

  const ProfileEditState({
    required this.name,
    required this.username,
    required this.bio,
    required this.selectedStyles,
    required this.profileImage,
    this.isSaving = false,
  });

  ProfileEditState copyWith({
    String? name,
    String? username,
    String? bio,
    List<String>? selectedStyles,
    String? profileImage,
    bool? isSaving,
  }) {
    return ProfileEditState(
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      selectedStyles: selectedStyles ?? this.selectedStyles,
      profileImage: profileImage ?? this.profileImage,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object> get props => [
    name,
    username,
    bio,
    selectedStyles,
    profileImage,
    isSaving,
  ];
}
