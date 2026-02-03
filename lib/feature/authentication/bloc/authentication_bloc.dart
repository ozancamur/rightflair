import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/services/messaging.dart';
import 'package:rightflair/core/services/authentication.dart';

import '../../../core/constants/string.dart';
import '../model/user.dart';
import '../repository/authentication_repository_impl.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseMessagingManager _messaging = FirebaseMessagingManager();
  final AuthenticationService _authentication = AuthenticationService();

  final AuthenticationRepositoryImpl _repo;
  AuthenticationBloc(this._repo) : super(AuthenticationInitial()) {
    on<AuthenticationRegisterEvent>(_onRegister);
    on<AuthenticationLoginEvent>(_onLogin);
    on<AuthtenticationAppleEvent>(_onApple);
    on<AuthtenticationGoogleEvent>(_onGoogle);
    on<AuthenticationResetPasswordEvent>(_onReset);
  }

  Future<void> _onRegister(
    AuthenticationRegisterEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final response = await _authentication.signUpWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );
    final String? uid = response.user?.id;
    if (uid == null) {
      emit(AuthenticationError(AppStrings.AUTHENTICATION_REGISTER_ERROR.tr()));
      return;
    }
    final UserModel? user = await _create(id: uid, email: event.email);
    if (user == null) {
      emit(AuthenticationError(AppStrings.AUTHENTICATION_REGISTER_ERROR.tr()));
    } else {
      emit(AuthenticationSuccess());
    }
  }

  Future<void> _onLogin(
    AuthenticationLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final response = await _authentication.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    final String? uid = response.user?.id;
    if (uid == null) {
      emit(AuthenticationError(""));
      return;
    }

    emit(AuthenticationSuccess());
  }

  Future<void> _onApple(
    AuthtenticationAppleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final response = await _authentication.signInWithApple();
    final String? uid = response.user?.id;
    if (uid == null) return;

    final UserModel? user = await _create(
      id: uid,
      email: response.user?.email ?? "",
    );
    if (user == null) {
      emit(AuthenticationError(AppStrings.AUTHENTICATION_REGISTER_ERROR.tr()));
    } else {
      emit(AuthenticationSuccess());
    }
  }

  Future<void> _onGoogle(
    AuthtenticationGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final response = await _authentication.signInWithGoogle();

    final String? uid = response.user?.id;
    if (uid == null) return;

    final UserModel? user = await _create(
      id: uid,
      email: response.user?.email ?? "",
    );
    if (user == null) {
      emit(AuthenticationError(AppStrings.AUTHENTICATION_REGISTER_ERROR.tr()));
    } else {
      emit(AuthenticationSuccess());
    }
  }

  Future<void> _onReset(
    AuthenticationResetPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  Future<UserModel?> _create({
    required String id,
    required String email,
    String? fullName,
  }) async {
    final String? fcm = await _messaging.getToken();
    final UserModel user = UserModel(
      id: id,
      email: email,
      fullName: fullName,
      followersCount: 0,
      followingCount: 0,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
      fcm: fcm,
    );

    final response = await _repo.createUser(user: user);
    return response;
  }
}
