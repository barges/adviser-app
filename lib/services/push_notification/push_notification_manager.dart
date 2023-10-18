abstract class PushNotificationManager {
  Future<void> registerForPushNotifications();

  Future<String?> getToken();
}
