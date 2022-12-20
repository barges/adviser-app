import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
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
      logger.d('+++++++++++++++++++++++');
      logger.d(response.notificationResponseType);
      logger.d(response.payload);
      logger.d(response.id);
      logger.d(response.actionId);
      logger.d(response.input);
      logger.d('+++++++++++++++++++++++');
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
      logger.d('***********************');
      logger.d(message.toMap());
      logger.d(message.data);
      logger.d(message.data['meta']);
      Map<String, dynamic> map = jsonDecode(message.data['meta'] ?? '');
      logger.d(map['entityId']);
      logger.d('***********************');
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
    Map<String, dynamic> data = message.data;

    Map<String, dynamic> meta = json.decode(data['meta']);
    String? entityId = meta['entityId'];
    String? type = meta['type'];

    if (entityId != null && type != null) {
      if (type == PushType.private.name) {
        Get.toNamed(AppRoutes.chat,
            arguments: ChatScreenArguments(privateQuestionId: entityId));
      } else if (type == PushType.session.name) {
        Get.toNamed(AppRoutes.chat,
            arguments: ChatScreenArguments(ritualID: entityId));
      } else if (type == PushType.tips.name) {
        Get.toNamed(AppRoutes.chat,
            arguments: ChatScreenArguments(clientId: entityId));
      }
    }
  }
}

enum PushType {
  private,
  session,
  tips,
}
