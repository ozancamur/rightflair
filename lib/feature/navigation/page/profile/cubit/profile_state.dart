part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final UserModel user;
  final StyleTagsModel? tags;
  final List<PhotoModel> photos;
  final bool isPhotosLoading;
  final List<PhotoModel> saves;
  final bool isSavesLoading;
  final List<PhotoModel> drafts;
  final bool isDraftsLoading;
  const ProfileState({
    this.isLoading = false,
    required this.user,
    this.tags,
    this.photos = const [],
    this.isPhotosLoading = false,
    this.saves = const [],
    this.isSavesLoading = false,
    this.drafts = const [],
    this.isDraftsLoading = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserModel? user,
    StyleTagsModel? tags,
    List<PhotoModel>? photos,
    bool? isPhotosLoading,
    List<PhotoModel>? saves,
    bool? isSavesLoading,
    List<PhotoModel>? drafts,
    bool? isDraftsLoading,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      tags: tags ?? this.tags,
      photos: photos ?? this.photos,
      isPhotosLoading: isPhotosLoading ?? this.isPhotosLoading,
      saves: saves ?? this.saves,
      isSavesLoading: isSavesLoading ?? this.isSavesLoading,
      drafts: drafts ?? this.drafts,
      isDraftsLoading: isDraftsLoading ?? this.isDraftsLoading,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    user,
    tags ?? StyleTagsModel(),
    photos,
    isPhotosLoading,
    saves,
    isSavesLoading,
    drafts,
    isDraftsLoading,
  ];
}
