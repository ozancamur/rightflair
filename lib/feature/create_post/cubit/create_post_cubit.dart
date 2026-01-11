import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/create_post_repository.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostRepository _repo;

  CreatePostCubit(this._repo) : super(const CreatePostState());

  void toggleAnonymous(bool value) {
    emit(state.copyWith(isAnonymous: value));
  }

  void toggleAllowComments(bool value) {
    emit(state.copyWith(allowComments: value));
  }

  void updateLocation(String? location) {
    emit(state.copyWith(selectedLocation: location));
  }

  Future<void> createPost() async {
    await _repo.createPost();
  }
}
