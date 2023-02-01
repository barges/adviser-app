import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

bool _isRegisteredForPushNotifications = false;

final ReceivePort _receiveNotificationPort = ReceivePort();
const String _notificationPortChannel = 'communication_channel';

class PushNotificationManagerImpl implements PushNotificationManager {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> registerForPushNotifications() async {
    if (!_isRegisteredForPushNotifications) {
      _isRegisteredForPushNotifications = true;
      await _configure();
    }
  }

  void _configLocalNotification() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
    );
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

  Future<void> _configure() async {
    IsolateNameServer.registerPortWithName(
      _receiveNotificationPort.sendPort,
      _notificationPortChannel,
    );
    _receiveNotificationPort.listen((dynamic message) {
      logger.d(message);
      if (message is Map<String, dynamic>) {
        Map<String, dynamic> map = jsonDecode(message['meta'] ?? '{}');
        if (map['type'] != null &&
            map['type'] == PushType.public_returned.name) {
          getIt.get<MainCubit>().updateSessions();
        }
      }
    });
    _configLocalNotification();
    await _setUpFirebaseMessaging();
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
        icon: 'ic_stat_reader_app_push',
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

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message == null) {
        final NotificationAppLaunchDetails? notificationAppLaunchDetails =
            await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();
        if (notificationAppLaunchDetails != null &&
            notificationAppLaunchDetails.didNotificationLaunchApp) {
          String? payload =
              notificationAppLaunchDetails.notificationResponse?.payload;
          logger.d(
              'FCM: didNotificationLaunchApp = ${notificationAppLaunchDetails.didNotificationLaunchApp}, payload = $payload');
          if (payload != null && payload.isNotEmpty) {
            Map<String, dynamic> data = jsonDecode(payload);
            _navigateToNextScreen(RemoteMessage(data: data));
          }
        }
      } else {
        _navigateToNextScreen(message);
      }
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
      if (map['type'] != null && map['type'] == PushType.public_returned.name) {
        getIt.get<MainCubit>().updateSessions();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_navigateToNextScreen);

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  logger.d('***********************');
  logger.d(message.toMap());
  logger.d(message.data);
  logger.d(message.data['meta']);
  Map<String, dynamic> map = jsonDecode(message.data['meta'] ?? '');
  logger.d(map['entityId']);
  logger.d('***********************');

  logger.d('On background');

  final SendPort? send =
      IsolateNameServer.lookupPortByName(_notificationPortChannel);

  send?.send(message.data);
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
            arguments: ChatScreenArguments(clientIdFromPush: entityId));
      } else if (type == PushType.public_returned.name) {
        Get.offNamedUntil(
          AppRoutes.home,
          (route) => route.settings.name != AppRoutes.home,
          arguments: HomeScreenArguments(initTab: TabsTypes.sessions),
        );

        // Get.offNamedUntil(AppRoutes.home, (route) => false,
        //    arguments: HomeScreenArguments(initTab: TabsTypes.sessions));
      }
    }
  }
}

enum PushType {
  private,
  session,
  tips,
  // ignore: constant_identifier_names
  public_returned,
}
