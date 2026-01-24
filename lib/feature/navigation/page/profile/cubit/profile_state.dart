part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final UserModel user;
  final StyleTagsModel? tags;

  final List<PostModel>? posts;
  final PaginationModel? postsPagination;
  final bool isPostsLoading;

  final List<PostModel>? saves;
  final bool isSavesLoading;

  final List<PostModel>? drafts;
  final bool isDraftsLoading;

  const ProfileState({
    this.isLoading = false,
    required this.user,
    this.tags,

    this.posts = const [],
    this.isPostsLoading = false,
    this.postsPagination,

    this.saves = const [],
    this.isSavesLoading = false,

    this.drafts = const [],
    this.isDraftsLoading = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserModel? user,
    StyleTagsModel? tags,

    List<PostModel>? posts,
    bool? isPostsLoading,
    PaginationModel? postsPagination,

    List<PostModel>? saves,
    bool? isSavesLoading,

    List<PostModel>? drafts,
    bool? isDraftsLoading,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      tags: tags ?? this.tags,

      posts: posts ?? this.posts,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      postsPagination: postsPagination ?? this.postsPagination,

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
    posts ?? [],
    isPostsLoading,
    saves ?? [],
    isSavesLoading,
    drafts ?? [],
    isDraftsLoading,
  ];
}
