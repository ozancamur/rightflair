import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../model/notifications.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final String? username;
  final String? email;
  final bool? emailVerified;
  final NotificationsModel? notifications;
  final ThemeMode themeMode;

  const SettingsState({
    this.isLoading = false,
    this.username = "@rightflair",
    this.email = "rightflair@example.com",
    this.emailVerified = false,
    this.notifications,
    this.themeMode = ThemeMode.system,
  });

  SettingsState copyWith({
    bool? isLoading,
    String? username,
    String? email,
    bool? emailVerified,
    NotificationsModel? notifications,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      notifications: notifications ?? this.notifications,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    username,
    email,
    emailVerified,
    notifications,
    themeMode,
  ];
}
