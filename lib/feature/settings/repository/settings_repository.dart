import '../model/notifications.dart';
import '../model/settings.dart';

abstract class SettingsRepository {
  Future<SettingsModel> getSettings();
  Future<void> updateSettings({required NotificationsModel notifications});
}
