import 'dart:io';

import 'package:shared_advisor_interface/analytics/analytics_params.dart';
import 'package:shared_advisor_interface/analytics/analytics_values.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

class AnalyticsEvent {
  late final String name;
  late final Map<String, String>? params;

  static const String chatRingName = 'chat ring';
  static const String chatAnsweredName = 'chat answered';
  static const String becameAvailableName = 'became available';
  static const String becameUnavailableName = 'became unavailable';
  static const String chatBecameAvailableName = 'chat became available';
  static const String chatBecameUnavailableName = 'chat became unavailable';
  static const String voiceBecameAvailableName = 'voice became available';
  static const String voiceBecameUnavailableName = 'voice became unavailable';
  static const String socketConnectedName = 'socket connected';
  static const String socketDisconnectName = 'socket disconnect';

  AnalyticsEvent({required this.name, this.params});

  void setParams(
    Map<String, String> params,
    BaseBrand brand,
    ZodiacCachingManager zodiacCachingManager,
  ) {
    final DateTime dateTimeNow = DateTime.now();

    params[AnalyticsParams.day] = dateTimeNow.day.toString();
    params[AnalyticsParams.dayOfWeek] = dateTimeNow.weekday.toString();
    params[AnalyticsParams.hourOfDay] = dateTimeNow.hour.toString();
    params[AnalyticsParams.month] = dateTimeNow.month.toString();
    params[AnalyticsParams.year] = dateTimeNow.year.toString();
    params[AnalyticsParams.yearMonth] =
        '${params[AnalyticsParams.year]}-${dateTimeNow.month < 10 ? '0${params[AnalyticsParams.month]}' : params[AnalyticsParams.month]}';
    params[AnalyticsParams.language] = brand.languageCode ?? '';

    final advisorModes = [];
    if (zodiacCachingManager.getUserStatus() == ZodiacUserStatus.online) {
      advisorModes.add(AnalyticsValues.available);
    }
    if (zodiacCachingManager.getDetailedUserInfo()?.details?.chatEnabled == 1) {
      advisorModes.add(AnalyticsValues.chat);
    }
    if (zodiacCachingManager.getDetailedUserInfo()?.details?.callEnabled == 1) {
      advisorModes.add(AnalyticsValues.voice);
    }
    params[AnalyticsParams.advisorModes] = advisorModes.toString();
  }

  static AnalyticsEvent chatRing({
    required String advisorId,
    required String buyerId,
  }) {
    final WebSocketManager webSocketManager =
        zodiacGetIt.get<WebSocketManager>();
    String ringType = '';
    if (webSocketManager.currentState == WebSocketState.connected) {
      ringType = AnalyticsValues.socket;
    } else if (Platform.isAndroid) {
      ringType = AnalyticsValues.pushNotification;
    } else if (Platform.isIOS) {
      ringType = AnalyticsValues.voip;
    }

    var params = {
      AnalyticsParams.advisorId: advisorId,
      AnalyticsParams.buyerId: buyerId,
      AnalyticsParams.ringType: ringType,
    };

    return AnalyticsEvent(name: chatRingName, params: params);
  }

  static AnalyticsEvent chatAnswered({
    required String advisorId,
    required String buyerId,
  }) {
    var params = {
      AnalyticsParams.advisorId: advisorId,
      AnalyticsParams.buyerId: buyerId,
    };

    return AnalyticsEvent(name: chatAnsweredName, params: params);
  }

  static AnalyticsEvent becameAvailable({
    required String advisorId,
  }) {
    var params = {
      AnalyticsParams.advisorId: advisorId,
    };

    return AnalyticsEvent(name: becameAvailableName, params: params);
  }

  static AnalyticsEvent becameUnavailable({
    required String advisorId,
  }) {
    var params = {
      AnalyticsParams.advisorId: advisorId,
    };

    return AnalyticsEvent(name: becameUnavailableName, params: params);
  }

  static AnalyticsEvent chatBecameAvailable({
    required String advisorId,
  }) {
    var params = {
      AnalyticsParams.advisorId: advisorId,
    };

    return AnalyticsEvent(name: chatBecameAvailableName, params: params);
  }

  static AnalyticsEvent chatBecameUnavailable({
    required String advisorId,
  }) {
    var params = {
      AnalyticsParams.advisorId: advisorId,
    };

    return AnalyticsEvent(name: chatBecameUnavailableName, params: params);
  }

  static AnalyticsEvent voiceBecameAvailable({
    required String advisorId,
  }) {
    var params = {
      AnalyticsParams.advisorId: advisorId,
    };

    return AnalyticsEvent(name: voiceBecameAvailableName, params: params);
  }

  static AnalyticsEvent voiceBecameUnavailable({
    required String advisorId,
  }) {
    var params = {
      AnalyticsParams.advisorId: advisorId,
    };

    return AnalyticsEvent(name: voiceBecameUnavailableName, params: params);
  }

  static AnalyticsEvent socketConnected() {
    var params = {
      AnalyticsParams.socketType: AnalyticsValues.php,
    };

    return AnalyticsEvent(name: socketConnectedName, params: params);
  }

  static AnalyticsEvent socketDisconnect({
    required String reason,
    required bool closedByServer,
    required int socketLiveTime,
  }) {
    var params = {
      AnalyticsParams.reason: reason,
      AnalyticsParams.socketType: AnalyticsValues.php,
      AnalyticsParams.closedByServer: closedByServer.toString(),
      AnalyticsParams.socketLiveTime: socketLiveTime.toString(),
    };

    return AnalyticsEvent(name: socketDisconnectName, params: params);
  }
}
