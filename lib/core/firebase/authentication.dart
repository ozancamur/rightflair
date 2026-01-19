import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/utils/dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../error/auth.dart';

class FirebaseAuthenticationManager {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Error callback - UI katmanından set edilecek
  Function(BuildContext context, String message)? onError;

  bool get isUserLoggedIn => _auth.currentUser != null;
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
      
    } on FirebaseAuthException catch (e) {
      final errorMessage = handleAuthException(e);
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(context, message: errorMessage);
      }
      return null;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_SIGNUP.tr(args: [e.toString()]),
        );
      }
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      final errorMessage = handleAuthException(e);
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(context, message: errorMessage);
      }
      return null;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_SIGNIN.tr(args: [e.toString()]),
        );
      }
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle({BuildContext? context}) async {
    try {
      final GoogleSignInAccount user = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = user.authentication;

      // Firebase credential oluştur
      final credential = GoogleAuthProvider.credential(
        //accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase ile giriş yap
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      final errorMessage = handleAuthException(e);
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(context, message: errorMessage);
      }
      return null;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_GOOGLE.tr(args: [e.toString()]),
        );
      }
      return null;
    }
  }

  Future<UserCredential?> signInWithApple({BuildContext? context}) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (appleCredential.givenName != null ||
          appleCredential.familyName != null) {
        final displayName =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
        await userCredential.user?.updateDisplayName(displayName);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      final errorMessage = handleAuthException(e);
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(context, message: errorMessage);
      }
      return null;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_APPLE.tr(args: [e.toString()]),
        );
      }
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(
    String email, {
    BuildContext? context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      final errorMessage = handleAuthException(e);
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(context, message: errorMessage);
      }
      return false;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_PASSWORD_RESET.tr(
            args: [e.toString()],
          ),
        );
      }
      return false;
    }
  }

  Future<bool> logout({BuildContext? context}) async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      return true;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_SIGNOUT.tr(args: [e.toString()]),
        );
      }
      return false;
    }
  }

  Future<bool> deleteAccount({BuildContext? context}) async {
    try {
      await _auth.currentUser?.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      final errorMessage = handleAuthException(e);
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(context, message: errorMessage);
      }
      return false;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_DELETE_ACCOUNT.tr(
            args: [e.toString()],
          ),
        );
      }
      return false;
    }
  }

  Future<bool> sendEmailVerification({BuildContext? context}) async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return true;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_EMAIL_VERIFICATION.tr(
            args: [e.toString()],
          ),
        );
      }
      return false;
    }
  }

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Kullanıcı bilgilerini güncelle
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
    BuildContext? context,
  }) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
      await _auth.currentUser?.reload();
      return true;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_UPDATE_PROFILE.tr(
            args: [e.toString()],
          ),
        );
      }
      return false;
    }
  }

  /// Şifre değiştir
  Future<bool> updatePassword(
    String newPassword, {
    BuildContext? context,
  }) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      final errorMessage = handleAuthException(e);
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(context, message: errorMessage);
      }
      return false;
    } catch (e) {
      if (context != null && context.mounted) {
        await DialogUtils.showErrorDialog(
          context,
          message: AppStrings.ERROR_GENERIC_UPDATE_PASSWORD.tr(
            args: [e.toString()],
          ),
        );
      }
      return false;
    }
  }

  /// Firebase Auth hatalarını yönet
 
}
