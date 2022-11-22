import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

bool _isRegisteredForPushNotifications = false;

class PushNotificationManagerImpl implements PushNotificationManager {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> registerForPushNotifications() async {
    if (_isRegisteredForPushNotifications) {
      return;
    }
    _isRegisteredForPushNotifications = true;

    await _configure();
  }

  Future<void> _configure() async {
    _configLocalNotification();
    _setUpFirebaseMessaging();
  }

  void _configLocalNotification() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) async {
      final Map<String, dynamic> message = json.decode(response.payload ?? '');
      _navigateToNextScreen(RemoteMessage(data: message));
    });
  }

  static void showNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'shared_interface_channel',
        'Advisor Shared Interface',
        channelDescription: 'All app notifications',
        playSound: true,
        enableVibration: true,
        //icon: 'ic_stat_ic_notification',
        importance: Importance.max,
        priority: Priority.high,
      );
      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true);
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          id,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: json.encode(message.data));
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> _setUpFirebaseMessaging() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      logger.d(message?.data);
      _navigateToNextScreen(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d(message.data);
      showNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_navigateToNextScreen);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToNextScreen(message);
    });
  }
}

Future<void> _navigateToNextScreen(RemoteMessage? message) async {
  if (message != null) {
    /**
      Map<String, dynamic> data = message.data;
  
      
      Map<String, dynamic> meta = json.decode(data['meta']);
      if (meta['entityId'] != null) {
        ChatItem chatItem =
            await getIt.get<ChatsRepository>().getQuestion(id: meta['entityId']);
        Get.toNamed(AppRoutes.chat, arguments: chatItem);
      }
    */

  }
}
