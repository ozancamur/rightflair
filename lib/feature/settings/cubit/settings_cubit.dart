import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/feature/settings/repository/settings_repository_impl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/theme_notifier.dart';
import '../../../core/constants/route.dart';
import '../../../core/constants/string.dart';
import '../../../core/services/authentication.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AuthenticationService _auth = AuthenticationService();

  final SettingsRepositoryImpl _repo;
  SettingsCubit(this._repo) : super(SettingsState());

  Future<void> init(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    final themeMode = context.read<ThemeNotifier>().themeMode;
    final response = await _repo.getSettings();
    emit(
      state.copyWith(
        isLoading: false,
        username: response.username,
        email: response.email,
        emailVerified: _auth.emailVerified,
        notifications: response.notifications,
        themeMode: themeMode,
      ),
    );
  }

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  Future<void> toggleLikes(bool value) async {
    emit(
      state.copyWith(
        notifications: state.notifications?.copyWith(enableLikes: value),
      ),
    );
    await update();
  }

  Future<void> toggleSaves(bool value) async {
    emit(
      state.copyWith(
        notifications: state.notifications?.copyWith(enableSaves: value),
      ),
    );
    await update();
  }

  Future<void> toggleMilestones(bool value) async {
    emit(
      state.copyWith(
        notifications: state.notifications?.copyWith(enableMilestones: value),
      ),
    );
    await update();
  }

  Future<void> toggleTrending(bool value) async {
    emit(
      state.copyWith(
        notifications: state.notifications?.copyWith(enableTrending: value),
      ),
    );
    await update();
  }

  Future<void> toggleFollow(bool value) async {
    emit(
      state.copyWith(
        notifications: state.notifications?.copyWith(enableFollow: value),
      ),
    );
    await update();
  }

  void toggleDarkMode(BuildContext context, bool value) {
    Provider.of<ThemeNotifier>(context, listen: false).setTheme(value);
    final themeMode = value ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: themeMode));
  }

  void setThemeMode(BuildContext context, ThemeMode mode) {
    Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> logOut(BuildContext context) async {
    await _auth.signOut();
    if (context.mounted) {
      context.replaceNamed(RouteConstants.WELCOME);
    }
  }

  Future<void> deactivateAccount() async => await _repo.deleteUser();

  Future<void> openTermsOfUse() async {
    final uri = Uri.parse(AppConstants.TERMS);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $uri');
    }
  }

  Future<void> openPrivacyPolicy() async {
    final uri = Uri.parse(AppConstants.PRIVACY);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $uri');
    }
  }

  Future<void> onContact() async {
    try {
      final String subjectRaw = AppStrings.SETTINGS_SUPPORT_EMAIL_SUBJECT.tr();
      final String version = AppConstants.VERSION;
      final String uid = _auth.user?.id ?? 'N/A';
      final String bodyRaw =
          '''
        -> 
        ________________________________
        --------------------------------
        User ID: $uid
        App Version: $version
        ${AppConstants.APP_NAME}
        ________________________________
        ''';

      final String subject = Uri.encodeComponent(subjectRaw);
      final String body = Uri.encodeComponent(bodyRaw);

      final Uri emailUri = Uri.parse(
        'mailto:${AppConstants.CONTACT_EMAIL}'
        '?subject=$subject'
        '&body=$body',
      );

      await launchUrl(emailUri);
    } catch (e) {
      debugPrint("SETTINGS CONTROLLER _supportEmail ERROR :> $e");
    }
  }

  Future<void> update() async {
    if (state.notifications == null) return;
    await _repo.updateSettings(notifications: state.notifications!);
  }
}
