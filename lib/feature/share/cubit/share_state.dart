part of 'share_cubit.dart';

class ShareState extends Equatable {
  final bool isLoading;
  final bool isSending;
  final List<SearchUserModel> searchResults;
  final SearchUserModel? selectedUser;
  final ReportReason? selectedReportReason;

  const ShareState({
    this.isLoading = false,
    this.isSending = false,
    this.searchResults = const [],
    this.selectedUser,
    this.selectedReportReason,
  });

  ShareState copyWith({
    bool? isLoading,
    bool? isSending,
    List<SearchUserModel>? searchResults,
    SearchUserModel? selectedUser,
    bool clearSelectedUser = false,
    ReportReason? selectedReportReason,
  }) {
    return ShareState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      searchResults: searchResults ?? this.searchResults,
      selectedUser: clearSelectedUser
          ? null
          : (selectedUser ?? this.selectedUser),
      selectedReportReason: selectedReportReason ?? this.selectedReportReason,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSending,
    searchResults,
    selectedUser,
    selectedReportReason,
  ];
}
