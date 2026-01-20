import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/cloud/firebase/messaging.dart';
import 'package:rightflair/core/cloud/supabase/authentication.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseMessagingManager _messaging = FirebaseMessagingManager();
  final SupabaseAuthentication _authentication = SupabaseAuthentication();

  AuthenticationBloc() : super(AuthenticationInitial()) {
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
    print(
      "AUTHENTICATION BLOC : REGISTER RESPONSE SESSION: ${response.session?.toJson()}",
    );
    print(
      "AUTHENTICATION BLOC : REGISTER RESPONSE USER: ${response.user?.toJson()}",
    );
    final String? uid = response.user?.id;
    if (uid == null) {
      emit(AuthenticationError(""));
      return;
    }
    /* await _create(
      uid: uid,
      email: event.email,
      name: response.session.,
    );*/
    emit(AuthenticationSetUsername());
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

    print(
      "AUTHENTICATION BLOC : LOGIN RESPONSE SESSION: ${response.session?.toJson()}",
    );
    print(
      "AUTHENTICATION BLOC : LOGIN RESPONSE USER: ${response.user?.toJson()}",
    );
    final String? uid = response.user?.id;
    if (uid == null) {
      emit(AuthenticationError(""));
      return;
    }

    /* final String? token = await _messaging.getToken();
      final UserModel user = UserModel(
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
    */
    emit(AuthenticationSetUsername());
  }

  Future<void> _onApple(
    AuthtenticationAppleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final response = await _authentication.signInWithApple();

    print(
      "AUTHENTICATION BLOC : REGISTER APPLE SESSION: ${response.session?.toJson()}",
    );
    print(
      "AUTHENTICATION BLOC : REGISTER APPLE USER: ${response.user?.toJson()}",
    );
    final String? uid = response.user?.id;
    if (uid == null) return;

    /*  await _create(
        uid: uid,
        email: response.user?.email ?? "",
        name: response.user?.displayName,
      );
    */
    emit(AuthenticationSetUsername());
  }

  Future<void> _onGoogle(
    AuthtenticationGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final response = await _authentication.signInWithGoogle();
    print(
      "AUTHENTICATION BLOC : REGISTER GOOGLE SESSION: ${response.session?.toJson()}",
    );
    print(
      "AUTHENTICATION BLOC : REGISTER GOOGLE USER: ${response.user?.toJson()}",
    );
    final String? uid = response.user?.id;
    if (uid == null) return;

    /* await _create(
        uid: uid,
        email: response.user?.email ?? "",
        name: response.user?.displayName,
      );
    */
    emit(AuthenticationSetUsername());
  }

  Future<void> _onReset(
    AuthenticationResetPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  Future<void> _create({
    required String uid,
    required String email,
    String? name,
    String? password,
  }) async {
    /*final String? token = await _messaging.getToken();
    final UserModel user = UserModel(
      uid: uid,
      email: email,
      fullName: name,
      token: token,

    );
    await _firestoreAuthentication.createWithId(
      collection: CollectionEnum.USERS,
      id: uid,
      data: user,
    );
    final ProfileModel profile = ProfileModel(uid: uid);
    await _firestoreAuthentication.createWithId(
      collection: CollectionEnum.PROFILES,
      id: uid,
      data: profile,
    );*/
  }
}
