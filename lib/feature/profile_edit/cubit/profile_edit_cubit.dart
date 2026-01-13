import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  ProfileEditCubit()
    : super(
        const ProfileEditState(
          name: 'Lorem Ipsum',
          username: 'loremipsum',
          bio:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
          selectedStyles: ['Oversized', 'Streetwear', 'Modeling'],
          profileImage: '',
        ),
      );

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updateBio(String bio) {
    emit(state.copyWith(bio: bio));
  }

  void updateProfileImage(String imageUrl) {
    emit(state.copyWith(profileImage: imageUrl));
  }

  void addStyle(String style) {
    if (state.selectedStyles.length < 3 &&
        !state.selectedStyles.contains(style)) {
      final updatedStyles = List<String>.from(state.selectedStyles)..add(style);
      emit(state.copyWith(selectedStyles: updatedStyles));
    }
  }

  void removeStyle(String style) {
    final updatedStyles = List<String>.from(state.selectedStyles)
      ..remove(style);
    emit(state.copyWith(selectedStyles: updatedStyles));
  }

  Future<void> saveProfile() async {
    emit(state.copyWith(isSaving: true));
    // TODO: Implement save logic
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isSaving: false));
  }

  bool get canAddMoreStyles => state.selectedStyles.length < 3;
  int get remainingStyleSlots => 3 - state.selectedStyles.length;
}
