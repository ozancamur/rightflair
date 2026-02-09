part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<String> recentSearches;
  final bool isLoading;
  final List<PostModel> searchResults;
  final String? errorMessage;
  final int currentPage;
  final bool hasMoreResults;

  const SearchState({
    required this.recentSearches,
    required this.isLoading,
    required this.searchResults,
    this.errorMessage,
    required this.currentPage,
    required this.hasMoreResults,
  });

  factory SearchState.initial() {
    return const SearchState(
      recentSearches: [],
      isLoading: false,
      searchResults: [],
      errorMessage: null,
      currentPage: 1,
      hasMoreResults: true,
    );
  }

  SearchState copyWith({
    List<String>? recentSearches,
    bool? isLoading,
    List<PostModel>? searchResults,
    String? errorMessage,
    int? currentPage,
    bool? hasMoreResults,
  }) {
    return SearchState(
      recentSearches: recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this.isLoading,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreResults: hasMoreResults ?? this.hasMoreResults,
    );
  }

  @override
  List<Object?> get props => [
    recentSearches,
    isLoading,
    searchResults,
    errorMessage,
    currentPage,
    hasMoreResults,
  ];
}
