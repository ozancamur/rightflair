import 'package:equatable/equatable.dart';

import '../model/notifications.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final String? username;
  final String? email;
  final bool? emailVerified;
  final NotificationsModel? notifications;
  final bool isDarkMode;

  const SettingsState({
    this.isLoading = false,
    this.username = "@rightflair",
    this.email = "rightflair@example.com",
    this.emailVerified = false,
    this.notifications,
    this.isDarkMode = false,
  });

  SettingsState copyWith({
    bool? isLoading,
    String? username,
    String? email,
    bool? emailVerified,
    NotificationsModel? notifications,
    bool? isDarkMode,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      notifications: notifications ?? this.notifications,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    username,
    email,
    emailVerified,
    notifications,
    isDarkMode,
  ];
}
