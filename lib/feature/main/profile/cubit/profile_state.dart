part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final UserModel user;
  final StyleTagsModel? tags;

  final List<PostModel>? posts;
  final PaginationModel? postsPagination;
  final bool isPostsLoading;
  final bool isLoadingMorePosts;

  final List<PostModel>? saves;
  final PaginationModel? savesPagination;
  final bool isSavesLoading;
  final bool isLoadingMoreSaves;

  final List<PostModel>? drafts;
  final PaginationModel? draftsPagination;
  final bool isDraftsLoading;
  final bool isLoadingMoreDrafts;

  const ProfileState({
    this.isLoading = false,
    required this.user,
    this.tags,

    this.posts = const [],
    this.isPostsLoading = false,
    this.postsPagination,
    this.isLoadingMorePosts = false,

    this.saves = const [],
    this.isSavesLoading = false,
    this.savesPagination,
    this.isLoadingMoreSaves = false,

    this.drafts = const [],
    this.isDraftsLoading = false,
    this.draftsPagination,
    this.isLoadingMoreDrafts = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserModel? user,
    StyleTagsModel? tags,

    List<PostModel>? posts,
    bool? isPostsLoading,
    PaginationModel? postsPagination,
    bool? isLoadingMorePosts,

    List<PostModel>? saves,
    bool? isSavesLoading,
    PaginationModel? savesPagination,
    bool? isLoadingMoreSaves,

    List<PostModel>? drafts,
    bool? isDraftsLoading,
    PaginationModel? draftsPagination,
    bool? isLoadingMoreDrafts,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      tags: tags ?? this.tags,

      posts: posts ?? this.posts,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      postsPagination: postsPagination ?? this.postsPagination,
      isLoadingMorePosts: isLoadingMorePosts ?? this.isLoadingMorePosts,

      saves: saves ?? this.saves,
      isSavesLoading: isSavesLoading ?? this.isSavesLoading,
      savesPagination: savesPagination ?? this.savesPagination,
      isLoadingMoreSaves: isLoadingMoreSaves ?? this.isLoadingMoreSaves,

      drafts: drafts ?? this.drafts,
      isDraftsLoading: isDraftsLoading ?? this.isDraftsLoading,
      draftsPagination: draftsPagination ?? this.draftsPagination,
      isLoadingMoreDrafts: isLoadingMoreDrafts ?? this.isLoadingMoreDrafts
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    user,
    tags ?? StyleTagsModel(),
    posts ?? [],

    isPostsLoading,
    postsPagination ?? PaginationModel(),
    isLoadingMorePosts,
    
    saves ?? [],
    isSavesLoading,
    savesPagination ?? PaginationModel(),
    isLoadingMoreSaves,

    drafts ?? [],
    isDraftsLoading,
    draftsPagination ?? PaginationModel(),
    isLoadingMoreDrafts,
  ];
}
