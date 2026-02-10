import '../../../main/inbox/model/response_notifications.dart';

abstract class SystemNotificationsRepository {
  Future<ResponseNotificationsModel?> getSystemNotifications({required int page});

}