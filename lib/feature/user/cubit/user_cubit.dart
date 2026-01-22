import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/user/repository/user_repository_impl.dart';

import '../../authentication/model/user.dart';
import '../../navigation/page/profile/model/photo.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepositoryImpl _repo;
  UserCubit(this._repo)
    : super(
        UserState(
          user: UserModel(),
          isLoading: false,
          photos: [
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1657460312/tr/foto%C4%9Fraf/beautiful-sensual-woman.jpg?s=1024x1024&w=is&k=20&c=mpNuQR920Mv2wZoFr-J13OOjS_rjcNNVZmusAvqMYV8=',
              viewed: 1242,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1362588255/tr/foto%C4%9Fraf/beautiful-brunette-woman-walking-on-sunset-beach-in-fashionable-maxi-dress-relaxing-on.jpg?s=1024x1024&w=is&k=20&c=hKza9LJ80QTYijNY1kMKKuRjhA6J00-1x8gh943g0gc=',

              viewed: 432,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1311415818/tr/foto%C4%9Fraf/giyindim-ve-hayallerimin-pe%C5%9Finden-gitmeye-haz%C4%B1r.jpg?s=1024x1024&w=is&k=20&c=UMSoGayVya20IjU0AKsGNs1EnFf_HKZ7pX-B5_MliM0=',
              viewed: 521,
            ),
            PhotoModel(
              url:
                  'https://media.istockphoto.com/id/1462655622/tr/foto%C4%9Fraf/beautiful-woman-in-a-leather-suit-looking-masculine.jpg?s=1024x1024&w=is&k=20&c=z3rSRE4jNYtQ0lD2Lzn0_idWA-o9SElixR-qwY3M4Ss=',
              viewed: 1,
            ),
          ],
        ),
      );

  Future<void> init(BuildContext context, {required String userId}) async {
    await _getUser(userId: userId);
    await _getUserStyleTags(userId: userId);
  }

  Future<void> _getUser({required String userId}) async {
    emit(state.copyWith(isLoading: true));
    final UserModel? user = await _repo.getUser(userId: userId);
    emit(state.copyWith(isLoading: false, user: user ?? UserModel()));
  }

  Future<void> _getUserStyleTags({required String userId}) async {
    final response = await _repo.getUserStyleTags(userId: userId);
    emit(state.copyWith(tags: response));
  }

  _getUserPosts({required String userId}) async {
    await _repo.getUserPosts(userId: userId);
  }
}
