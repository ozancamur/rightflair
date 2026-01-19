import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/firebase/authentication.dart';

import '../../../core/firebase/firestore/firestore_authentication.dart';

part 'choose_username_state.dart';

class ChooseUsernameCubit extends Cubit<ChooseUsernameState> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  final FirestoreAuthenticationManager _firestoreAuthentication =
      FirestoreAuthenticationManager();
  final FirebaseAuthenticationManager _authentication =
      FirebaseAuthenticationManager();

  ChooseUsernameCubit() : super(ChooseUsernameState());

  Future<void> onSave(BuildContext context) async {
    try {
      if (controller.text.trim().isEmpty) return;
      emit(state.copyWith(isLoading: true));
      final isUnique = await _firestoreAuthentication.isUsernameUnique(
        controller.text,
      );
      emit(state.copyWith(isUnique: isUnique));
      if (isUnique) {
        try {
          final uid = _authentication.currentUser?.uid;
          if (uid == null) {
            emit(state.copyWith(isLoading: false));
            return;
          }
          await _firestoreAuthentication.saveUsername(
            uid: uid,
            username: controller.text,
          );
          if (context.mounted) {
            emit(state.copyWith(isLoading: true));
            context.replace(RouteConstants.NAVIGATION);
          }
        } catch (e) {
          debugPrint('Kullanıcı adı kaydedilirken hata oluştu: $e');
          emit(state.copyWith(isLoading: false));
        }
      }
    } catch (e) {
      debugPrint('Username kaydedilemedi: $e');
      emit(state.copyWith(isLoading: false));
    }
  }
}
