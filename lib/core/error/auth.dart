import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/string.dart';

String handleAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'weak-password':
      return AppStrings.ERROR_WEAK_PASSWORD.tr();
    case 'email-already-in-use':
      return AppStrings.ERROR_EMAIL_ALREADY_IN_USE.tr();
    case 'invalid-email':
      return AppStrings.ERROR_INVALID_EMAIL.tr();
    case 'user-not-found':
      return AppStrings.ERROR_USER_NOT_FOUND.tr();
    case 'wrong-password':
      return AppStrings.ERROR_WRONG_PASSWORD.tr();
    case 'user-disabled':
      return AppStrings.ERROR_USER_DISABLED.tr();
    case 'too-many-requests':
      return AppStrings.ERROR_TOO_MANY_REQUESTS.tr();
    case 'operation-not-allowed':
      return AppStrings.ERROR_OPERATION_NOT_ALLOWED.tr();
    case 'requires-recent-login':
      return AppStrings.ERROR_REQUIRES_RECENT_LOGIN.tr();
    case 'invalid-credential':
      return AppStrings.ERROR_INVALID_CREDENTIAL.tr();
    case 'account-exists-with-different-credential':
      return AppStrings.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL.tr();
    default:
      return AppStrings.ERROR_DEFAULT.tr(args: [e.message ?? '']);
  }
}
