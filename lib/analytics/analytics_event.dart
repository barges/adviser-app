import 'dart:io';

import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

class AnalyticsEvent {
  late final String name;
  late final Map<String, String>? params;

  AnalyticsEvent({required this.name, this.params});

  void setParams(
    Map<String, String> params,
    BaseBrand brand,
    ZodiacCachingManager zodiacCachingManager,
  ) {
    final DateTime dateTimeNow = DateTime.now();

    params['day'] = dateTimeNow.day.toString();
    params['day of week'] = dateTimeNow.weekday.toString();
    params['hour of day'] = dateTimeNow.hour.toString();
    params['month'] = dateTimeNow.month.toString();
    params['year'] = dateTimeNow.year.toString();
    params['year-month'] =
        '${params['year']}-${dateTimeNow.month < 10 ? '0${params['month']}' : params['month']}';
    params['language'] = brand.languageCode ?? '';

    final advisorModes = [];
    if (zodiacCachingManager.getUserStatus() == ZodiacUserStatus.online) {
      advisorModes.add('available');
    }
    if (zodiacCachingManager.getDetailedUserInfo()?.details?.chatEnabled == 1) {
      advisorModes.add('chat');
    }
    if (zodiacCachingManager.getDetailedUserInfo()?.details?.callEnabled == 1) {
      advisorModes.add('voice');
    }
    params['advisor modes'] = advisorModes.toString();
  }

  static AnalyticsEvent chatRing({
    required String advisorId,
    required String buyerId,
  }) {
    final WebSocketManager webSocketManager =
        zodiacGetIt.get<WebSocketManager>();
    String ringType = '';
    if (webSocketManager.currentState == WebSocketState.connected) {
      ringType = 'socket';
    } else if (Platform.isAndroid) {
      ringType = 'push notification';
    } else if (Platform.isIOS) {
      ringType = 'voip';
    }

    var params = {
      'advisor id': advisorId,
      'buyer id': buyerId,
      'ring type': ringType,
    };

    return AnalyticsEvent(name: "chat ring", params: params);
  }

  static AnalyticsEvent chatAnswered({
    required String advisorId,
    required String buyerId,
  }) {
    var params = {
      'advisor id': advisorId,
      'buyer id': buyerId,
    };

    return AnalyticsEvent(name: "chat answered", params: params);
  }

  static AnalyticsEvent becameUnavailable({
    required String advisorId,
  }) {
    var params = {
      'advisor id': advisorId,
    };

    return AnalyticsEvent(name: "became unavailable", params: params);
  }

  static AnalyticsEvent becameAvailable({
    required String advisorId,
  }) {
    var params = {
      'advisor id': advisorId,
    };

    return AnalyticsEvent(name: "became available", params: params);
  }

  static AnalyticsEvent chatBecameAvailable({
    required String advisorId,
  }) {
    var params = {
      'advisor id': advisorId,
    };

    return AnalyticsEvent(name: "chat became available", params: params);
  }

  static AnalyticsEvent chatBecameUnavailable({
    required String advisorId,
  }) {
    var params = {
      'advisor id': advisorId,
    };

    return AnalyticsEvent(name: "chat became unavailable", params: params);
  }

  static AnalyticsEvent voiceBecameAvailable({
    required String advisorId,
  }) {
    var params = {
      'advisor id': advisorId,
    };

    return AnalyticsEvent(name: "voice became available", params: params);
  }

  static AnalyticsEvent voiceBecameUnavailable({
    required String advisorId,
  }) {
    var params = {
      'advisor id': advisorId,
    };

    return AnalyticsEvent(name: "voice became unavailable", params: params);
  }

  static AnalyticsEvent socketConnected() {
    var params = {
      'socket type': 'php',
    };

    return AnalyticsEvent(name: "socket connected", params: params);
  }

  static AnalyticsEvent socketDisconnect({
    required String reason,
    required bool closedByServer,
    required int socketLiveTime,
  }) {
    var params = {
      'reason': reason,
      'socket type': 'php',
      'closed by server': closedByServer.toString(),
      'socket live time': socketLiveTime.toString(),
    };

    return AnalyticsEvent(name: "socket disconnect", params: params);
  }
}
