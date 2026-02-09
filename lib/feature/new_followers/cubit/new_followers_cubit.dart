import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/pagination_notification.dart';
import 'package:rightflair/feature/new_followers/repository/new_followers_repository_impl.dart';

import '../../navigation/page/inbox/model/notification_sender.dart';
import '../model/new_follower.dart';

part 'new_followers_state.dart';

class NewFollowersCubit extends Cubit<NewFollowersState> {
  final NewFollowersRepositoryImpl _repo;
  NewFollowersCubit(this._repo) : super(NewFollowersState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoading: true));
    final notifications = await _repo.getNewFollowers();
    final suggested = await _repo.getSuggestedUsers();
    emit(
      state.copyWith(
        isLoading: false,
        notifications: notifications?.followers,
        pagination: notifications?.pagination,
        suggestedUsers: suggested?.suggestedUsers,
        paginationSuggested: suggested?.pagination,
      ),
    );
  }
}
