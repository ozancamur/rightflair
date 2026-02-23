import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/enums/report_reason.dart';
import 'package:rightflair/feature/main/profile/model/pagination.dart';
import 'package:rightflair/feature/share/model/share.dart';

import '../repository/share_repository_impl.dart';

part 'share_state.dart';

class ShareCubit extends Cubit<ShareState> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final ShareRepositoryImpl _repo;
  ShareCubit(this._repo) : super(const ShareState()) {
    _fetchUserList();
  }

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(searchResults: [], clearSelectedUser: true));
      return;
    }

    emit(state.copyWith(isLoading: true));

    final response = await _repo.searchUsers(
      query: query,
      pagination: PaginationModel().forSearchUsers(page: 1),
    );

    emit(
      state.copyWith(isLoading: false, searchResults: response?.users ?? []),
    );
  }

  void toggleUserSelection(SearchUserModel user) {
    if (state.selectedUser?.id == user.id) {
      emit(state.copyWith(clearSelectedUser: true));
    } else {
      emit(state.copyWith(selectedUser: user));
    }
  }

  Future<bool> shareProfile({required String referencedUserId}) async {
    final selectedUser = state.selectedUser;
    if (selectedUser?.id == null || referencedUserId.isEmpty) return false;

    emit(state.copyWith(isSending: true));

    final success = await _repo.shareProfile(
      recipientId: selectedUser!.id!,
      referencedUserId: referencedUserId,
    );

    emit(state.copyWith(isSending: false));
    return success;
  }

  Future<bool> sharePost({
    required String referencedPostId,
    String? content,
  }) async {
    final selectedUser = state.selectedUser;
    if (selectedUser?.id == null || referencedPostId.isEmpty) return false;

    emit(state.copyWith(isSending: true));

    final success = await _repo.sharePost(
      recipientId: selectedUser!.id!,
      referencedPostId: referencedPostId,
      content: content,
    );

    emit(state.copyWith(isSending: false));
    return success;
  }

  Future<bool> shareImage({required String imageUrl}) async {
    final selectedUser = state.selectedUser;
    if (selectedUser?.id == null || imageUrl.isEmpty) return false;

    emit(state.copyWith(isSending: true));

    final success = await _repo.shareImage(
      recipientId: selectedUser!.id!,
      imageUrl: imageUrl,
    );

    emit(state.copyWith(isSending: false));
    return success;
  }

  void selectReportReason(ReportReason reason) =>
      emit(state.copyWith(selectedReportReason: reason));

  Future<void> reportPost(String postId) async {
    final reason = state.selectedReportReason;
    if (reason == null) return;

    await _repo.reportPost(pId: postId, reason: reason);
  }

  Future<void> reportUser(String reportedId, {String? description}) async {
    final reason = state.selectedReportReason;
    if (reason == null) return;

    await _repo.reportUser(
      reportedId: reportedId,
      reason: reason,
      description: description,
    );
  }

  void clearSearch() {
    searchController.clear();
    emit(state.copyWith(searchResults: [], clearSelectedUser: true));
  }

  void toggleSearch() {
    final opening = !state.isSearchOpen;
    if (!opening) {
      searchController.clear();
      searchFocusNode.unfocus();
      emit(state.copyWith(isSearchOpen: false, searchResults: []));
    } else {
      emit(state.copyWith(isSearchOpen: true));
      Future.microtask(() => searchFocusNode.requestFocus());
    }
  }

  void closeSearch() {
    searchController.clear();
    searchFocusNode.unfocus();
    emit(state.copyWith(isSearchOpen: false, searchResults: []));
  }

  Future<void> _fetchUserList() async {
    emit(state.copyWith(isLoading: true));

    List<SearchUserModel>? response;
    response = await _repo.getShareSuggestions();

    if (response != null) {
      emit(state.copyWith(users: response, isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    searchFocusNode.dispose();
    return super.close();
  }
}
