import '../../../core/base/model/base.dart';
import 'notifications.dart';

class SettingsModel extends BaseModel<SettingsModel> {
  String? username;
  String? email;
  NotificationsModel? notifications;

  SettingsModel({this.username, this.email, this.notifications});

  @override
  SettingsModel copyWith({
    String? username,
    String? email,
    NotificationsModel? notifications,
  }) {
    return SettingsModel(
      username: username ?? this.username,
      email: email ?? this.email,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  SettingsModel fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      username: json['username'] as String?,
      email: json['email'] as String?,
      notifications: json['notifications'] != null
          ? NotificationsModel().fromJson(
              json['notifications'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'notifications': notifications?.toJson(),
    };
  }

  SettingsModel error() {
    return SettingsModel(
      notifications: NotificationsModel(
        enableLikes: false,
        enableSaves: false,
        enableMilestones: false,
        enableTrending: false,
        enableFollow: false,
      ),
    );
  }
}
