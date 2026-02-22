part of 'share_cubit.dart';

class ShareState extends Equatable {
  final bool isLoading;
  final bool isSending;
  final bool isSearchOpen;
  final List<SearchUserModel> searchResults;
  final SearchUserModel? selectedUser;
  final ReportReason? selectedReportReason;

  final List<SearchUserModel> users;

  const ShareState({
    this.isLoading = false,
    this.isSending = false,
    this.isSearchOpen = false,
    this.searchResults = const [],
    this.selectedUser,
    this.selectedReportReason,
    this.users = const [],
  });

  ShareState copyWith({
    bool? isLoading,
    bool? isSending,
    bool? isSearchOpen,
    List<SearchUserModel>? searchResults,
    SearchUserModel? selectedUser,
    bool clearSelectedUser = false,
    ReportReason? selectedReportReason,
    List<SearchUserModel>? users,
  }) {
    return ShareState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      isSearchOpen: isSearchOpen ?? this.isSearchOpen,
      searchResults: searchResults ?? this.searchResults,
      selectedUser: clearSelectedUser
          ? null
          : (selectedUser ?? this.selectedUser),
      selectedReportReason: selectedReportReason ?? this.selectedReportReason,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSending,
    isSearchOpen,
    searchResults,
    selectedUser,
    selectedReportReason,
    users,
  ];
}
