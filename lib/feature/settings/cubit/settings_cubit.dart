import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route.dart';
import '../../../main.dart';
import '../model/settings_model.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  void loadSettings({bool isDarkMode = false}) {
    emit(SettingsLoading());

    // Mock data - replace with actual data source
    final settings = SettingsModel(
      username: '@loremipsum',
      email: 'loremipsum@mail.com',
      likesEnabled: true,
      savesEnabled: true,
      milestonesEnabled: true,
      trendingEnabled: true,
      followEnabled: true,
      darkModeEnabled: isDarkMode,
      language: 'english',
    );

    emit(SettingsLoaded(settings));
  }

  void toggleLikes(bool value) {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(SettingsLoaded(currentState.settings.copyWith(likesEnabled: value)));
    }
  }

  void toggleSaves(bool value) {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(SettingsLoaded(currentState.settings.copyWith(savesEnabled: value)));
    }
  }

  void toggleMilestones(bool value) {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(
        SettingsLoaded(
          currentState.settings.copyWith(milestonesEnabled: value),
        ),
      );
    }
  }

  void toggleTrending(bool value) {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(
        SettingsLoaded(currentState.settings.copyWith(trendingEnabled: value)),
      );
    }
  }

  void toggleFollow(bool value) {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(
        SettingsLoaded(currentState.settings.copyWith(followEnabled: value)),
      );
    }
  }

  void toggleDarkMode(BuildContext context, bool value) {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      Provider.of<ThemeNotifier>(context, listen: false).setTheme(value);
      emit(
        SettingsLoaded(currentState.settings.copyWith(darkModeEnabled: value)),
      );
    }
  }

  void logOut(BuildContext context) {
    context.replaceNamed(RouteConstants.WELCOME);
  }

  void deactivateAccount() {
    // Implement account deactivation logic
  }
}
