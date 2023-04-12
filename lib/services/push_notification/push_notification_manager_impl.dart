import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fortunica/fortunica.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/infrastructure/routing/route_paths_fortunica.dart';
import 'package:fortunica/presentation/screens/chat/chat_screen.dart';
import 'package:fortunica/presentation/screens/home/tabs_types.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart';

bool _isRegisteredForPushNotifications = false;

final ReceivePort _receiveNotificationPort = ReceivePort();
const String _notificationPortChannel = 'communication_channel';

@Singleton(as: PushNotificationManager)
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

  @override
  Future<String?> getToken() async {
    return await messaging.getToken();
  }

  Future<void> _configure() async {
    IsolateNameServer.registerPortWithName(
      _receiveNotificationPort.sendPort,
      _notificationPortChannel,
    );
    _receiveNotificationPort.listen((dynamic message) {
      logger.d('ISOLATE PUSH NOTIFICATION LISTENER');
      if (message is Map<String, dynamic>) {
        Map<String, dynamic> map = jsonDecode(message['meta'] ?? '{}');
        _messageTypeHandler(map);
      }
    });

    _configLocalNotification();
    await _setUpFirebaseMessaging();
  }

  void _configLocalNotification() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
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
      logger.d('***********************');

      if (!Platform.isIOS) {
        showNotification(message);
      }
      Map<String, dynamic> map = jsonDecode(message.data['meta'] ?? '{}');
      _messageTypeHandler(map);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Map<String, dynamic> meta = jsonDecode(message.data['meta'] ?? '{}');
      final String? type = meta['type'];
      if (type != null && type != PushType.tips.name) {
        fortunicaGetIt.get<FortunicaMainCubit>().updateSessions();
      }

      _navigateToNextScreen(message);
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  logger.d('***********************');
  logger.d(message.toMap());
  logger.d('***********************');
  logger.d('On background');

  final SendPort? send =
      IsolateNameServer.lookupPortByName(_notificationPortChannel);

  send?.send(message.data);
}

void _messageTypeHandler(Map<String, dynamic> meta) {
  final BuildContext? fortunicaContext = FortunicaBrand().context;

  final String? type = meta['type'];
  if (type != null) {
    if (type == PushType.publicReturned.name) {
      if (fortunicaContext != null &&
          fortunicaContext.currentRoutePath == RoutePathsFortunica.chatScreen) {
        fortunicaContext
            .replaceAll([FortunicaAuth(initTab: TabsTypes.sessions)]);
      } else {
        fortunicaGetIt.get<FortunicaMainCubit>().updateSessions();
      }
    } else if (type != PushType.tips.name) {
      fortunicaGetIt.get<FortunicaMainCubit>().updateSessions();
    }
  }
}

Future<void> _navigateToNextScreen(RemoteMessage? message) async {
  final BuildContext? fortunicaContext = FortunicaBrand().context;

  if (FortunicaBrand().isAuth && fortunicaContext != null && message != null) {
    Map<String, dynamic> data = message.data;

    Map<String, dynamic> meta = json.decode(data['meta']);
    String? entityId = meta['entityId'];
    String? type = meta['type'];

    if (entityId != null && type != null) {
      if (type == PushType.private.name) {
        globalGetIt.get<MainCubit>().stopAudio();
        fortunicaContext.push(
            route: FortunicaChat(
          chatScreenArguments: ChatScreenArguments(privateQuestionId: entityId),
        ));
      } else if (type == PushType.session.name) {
        globalGetIt.get<MainCubit>().stopAudio();
        fortunicaContext.push(
            route: FortunicaChat(
          chatScreenArguments: ChatScreenArguments(ritualID: entityId),
        ));
      } else if (type == PushType.tips.name) {
        globalGetIt.get<MainCubit>().stopAudio();
        fortunicaContext.push(
            route: FortunicaChat(
          chatScreenArguments: ChatScreenArguments(clientIdFromPush: entityId),
        ));
      } else if (type == PushType.publicReturned.name) {
        fortunicaContext
            .replaceAll([FortunicaAuth(initTab: TabsTypes.sessions)]);
      }
    }
  }
}

enum PushType {
  private,
  session,
  tips,
  publicReturned;

  get name {
    switch (this) {
      case PushType.private:
        return 'private';
      case PushType.session:
        return 'session';
      case PushType.tips:
        return 'tips';
      case PushType.publicReturned:
        return 'public_returned';
    }
  }
}