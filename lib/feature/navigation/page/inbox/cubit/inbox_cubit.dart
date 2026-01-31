import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/inbox/repository/inbox_repository_impl.dart';
import 'package:rightflair/feature/navigation/page/inbox/cubit/inbox_state.dart';
import 'package:rightflair/feature/navigation/page/profile/model/pagination.dart';

class InboxCubit extends Cubit<InboxState> {
  final InboxRepositoryImpl _repo;
  InboxCubit(this._repo) : super(InboxState()) {
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    emit(state.copyWith(isLoading: true));
    final response = await _repo.fetchConversations(
      pagination: PaginationModel().forConversations(page: 1),
    );
    emit(state.copyWith(isLoading: false, conversations: response));
  }
}
