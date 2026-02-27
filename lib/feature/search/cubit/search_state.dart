part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<String> recentSearches;
  final bool isLoading;
  final bool isPaginating;
  final bool hasSearched;
  final List<SearchUserModel> results;
  final PaginationModel? pagination;

  const SearchState({
    required this.recentSearches,
    required this.isLoading,
    required this.isPaginating,
    required this.hasSearched,
    required this.results,
    required this.pagination,
  });

  factory SearchState.initial() {
    return const SearchState(
      recentSearches: [],
      isLoading: false,
      isPaginating: false,
      hasSearched: false,
      results: [],
      pagination: null,
    );
  }

  SearchState copyWith({
    List<String>? recentSearches,
    bool? isLoading,
    bool? isPaginating,
    bool? hasSearched,
    List<SearchUserModel>? results,
    PaginationModel? pagination,
  }) {
    return SearchState(
      recentSearches: recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      hasSearched: hasSearched ?? this.hasSearched,
      results: results ?? this.results,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [
    recentSearches,
    isLoading,
    isPaginating,
    hasSearched,
    results,
    pagination,
  ];
}
