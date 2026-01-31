import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/feature/choose_username/repository/choose_username_repository_impl.dart';

import '../../../core/constants/route.dart';

part 'choose_username_state.dart';

class ChooseUsernameCubit extends Cubit<ChooseUsernameState> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  final ChooseUsernameRepositoryImpl _repo;
  ChooseUsernameCubit(this._repo) : super(ChooseUsernameState());

  void onTextChanged() {
    final currentText = controller.text.toLowerCase().trim();
    if (state.checkedUsername != null && state.checkedUsername != currentText) {
      emit(state.copyWith(isUnique: false, checkedUsername: null));
    }
  }

  Future<void> onCheck(BuildContext context) async {
    try {
      if (controller.text.trim().isEmpty) return;
      final username = controller.text.toLowerCase();
      emit(state.copyWith(isLoading: true));

      final bool isUnique = await _repo.checkUsername(username: username);
      emit(
        state.copyWith(
          isLoading: false,
          isUnique: isUnique,
          checkedUsername: username,
        ),
      );
    } catch (e) {
      debugPrint('Username kaydedilemedi: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> onSave(BuildContext context, bool canPop) async {
    try {
      if (controller.text.trim().isEmpty) return;
      emit(state.copyWith(isLoading: true));
      final response = await _repo.updatedUser(
        username: controller.text.toLowerCase(),
      );
      if (response == null || response.success != true) {
        emit(state.copyWith(isLoading: false));
        return;
      } else {
        if (response.success == true && context.mounted) {
          if (canPop) {
            context.pop(controller.text);
          } else {
            context.go(RouteConstants.NAVIGATION);
          }
          emit(state.copyWith(isLoading: false, isUnique: false));
          controller.clear();
        }
      }
    } catch (e) {
      debugPrint('Username kaydedilemedi: $e');
      emit(state.copyWith(isLoading: false));
    }
  }
}
