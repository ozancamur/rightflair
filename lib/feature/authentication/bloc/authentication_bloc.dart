import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/collection.dart';
import 'package:rightflair/core/firebase/messaging.dart';

import '../../../core/firebase/authentication.dart';
import '../../../core/firebase/firestore/firestore_authentication.dart';
import '../model/user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuthenticationManager _authentication =
      FirebaseAuthenticationManager();
  final FirestoreAuthenticationManager _firestoreAuthentication =
      FirestoreAuthenticationManager();
  final FirebaseMessagingManager _messaging = FirebaseMessagingManager();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationRegisterEvent>(_onRegister);
    on<AuthenticationLoginEvent>(_onLogin);
    on<AuthtenticationAppleEvent>(_onApple);
    on<AuthtenticationGoogleEvent>(_onGoogle);
    on<AuthenticationResetPasswordEvent>(_onReset);
    on<AuthenticationSetUsernameEvent>(_onSetUsername);
    on<AuthenticationSaveUsernameEvent>(_onSaveUsername);
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
    if (response == null) {
      emit(AuthenticationError(""));
      return;
    }
    final String? uid = response.user?.uid;
    if (uid == null) {
      emit(AuthenticationError(""));
      return;
    }
    final isUserExists = await _firestoreAuthentication.isUserExists(uid);
    if (isUserExists) {
      final check = await _firestoreAuthentication.isUsernameNull(uid);
      if (check) {
        emit(AuthenticationSetUsername(isUnique: false));
      } else {
        emit(AuthenticationSuccess());
      }
    } else {
      final String? token = await _messaging.getToken();
      final ProfileModel user = ProfileModel(
        uid: uid,
        email: event.email,
        fullName: response.user?.displayName,
        token: token,
      );
      await _firestoreAuthentication.createWithId(
        collection: CollectionEnum.USERS,
        id: uid,
        data: user,
      );
      emit(AuthenticationSetUsername(isUnique: true));
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
    if (response == null) {
      emit(AuthenticationError(""));
      return;
    }
    final String? uid = response.user?.uid;
    if (uid == null) {
      emit(AuthenticationError(""));
      return;
    }
    final isUserExists = await _firestoreAuthentication.isUserExists(uid);
    if (isUserExists) {
      final check = await _firestoreAuthentication.isUsernameNull(uid);
      if (check) {
        emit(AuthenticationSetUsername(isUnique: false));
      } else {
        emit(AuthenticationSuccess());
      }
    } else {
      final String? token = await _messaging.getToken();
      final ProfileModel user = ProfileModel(
        uid: uid,
        fullName: response.user?.displayName,
        email: event.email,
        token: token,
      );
      await _firestoreAuthentication.createWithId(
        collection: CollectionEnum.USERS,
        id: uid,
        data: user,
      );
    }
  }

  Future<void> _onApple(
    AuthtenticationAppleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final response = await _authentication.signInWithApple();
    if (response == null) {
      emit(AuthenticationError(""));
      return;
    }
    final String? uid = response.user?.uid;
    if (uid == null) return;
    final isUserExists = await _firestoreAuthentication.isUserExists(uid);
    if (isUserExists) {
      final check = await _firestoreAuthentication.isUsernameNull(uid);
      if (check) {
        emit(AuthenticationSetUsername(isUnique: false));
      } else {
        emit(AuthenticationSuccess());
      }
    } else {
      final String? token = await _messaging.getToken();
      final ProfileModel user = ProfileModel(
        uid: uid,
        fullName: response.user?.displayName,
        email: response.user?.email,
        token: token,
      );
      await _firestoreAuthentication.createWithId(
        collection: CollectionEnum.USERS,
        id: uid,
        data: user,
      );
    }
  }

  Future<void> _onGoogle(
    AuthtenticationGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final response = await _authentication.signInWithGoogle();
    if (response == null) {
      emit(AuthenticationError(""));
      return;
    }
    final String? uid = response.user?.uid;
    if (uid == null) return;
    final isUserExists = await _firestoreAuthentication.isUserExists(uid);
    if (isUserExists) {
      final check = await _firestoreAuthentication.isUsernameNull(uid);
      if (check) {
        emit(AuthenticationSetUsername(isUnique: false));
      } else {
        emit(AuthenticationSuccess());
      }
    } else {
      final String? token = await _messaging.getToken();
      final ProfileModel user = ProfileModel(
        uid: uid,
        fullName: response.user?.displayName,
        email: response.user?.email,
        token: token,
      );
      await _firestoreAuthentication.createWithId(
        collection: CollectionEnum.USERS,
        id: uid,
        data: user,
      );
    }
  }

  Future<void> _onReset(
    AuthenticationResetPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    await _authentication.sendPasswordResetEmail(event.email);
  }

  Future<void> _onSetUsername(
    AuthenticationSetUsernameEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final isUnique = await _firestoreAuthentication.isUsernameUnique(
      event.username,
    );
    emit(AuthenticationSetUsername(isUnique: isUnique));
  }

  Future<void> _onSaveUsername(
    AuthenticationSaveUsernameEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final uid = _authentication.currentUser?.uid;
      if (uid == null) {
        emit(AuthenticationError("Kullanıcı bulunamadı"));
        return;
      }
      await _firestoreAuthentication.saveUsername(
        uid: uid,
        username: event.username,
      );
      emit(AuthenticationSuccess());
    } catch (e) {
      emit(AuthenticationError("Username kaydedilemedi"));
    }
  }
}
