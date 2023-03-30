import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';

const String appName = 'Advisor Shared Interface';

abstract class FreshChatService {
  Future<bool> setUpFortunicaFreshChat(FreshChaUserInfo? userInfo);

  Future<void> initFreshChat(bool isDarkMode);

  Stream onRestoreStream();

  Future<String?> getRestoreId();

  void changeLocaleInvite();

  bool get isInit;
}

@Singleton(as: FreshChatService)
class FreshChatServiceImpl extends FreshChatService {
  static const String freshChatId = 'ad263ea2-8218-4618-88bd-220ab8d56e23';
  static const String freshChatKey = 'd77300c3-b490-46f6-86d9-226b4e79c737';
  static const String freshChatDomain = 'msdk.freshchat.com';
  bool _wasInit = false;

  @override
  bool get isInit => _wasInit;

  @override
  Future initFreshChat(bool isDarkMode) async {
    Freshchat.init(freshChatId, freshChatKey, freshChatDomain,
        stringsBundle: 'FCCustomLocalizable',
        themeName: isDarkMode ? 'FCDarkTheme.plist' : 'FCTheme.plist');
    _wasInit = true;
  }

  @override
  Future<bool> setUpFortunicaFreshChat(FreshChaUserInfo? userInfo) async {
    if (!_wasInit) {
      throw Exception([
        'Fresh Chat Manager was not init. Pleas use initFreshChat() before setUpFreshChat.'
      ]);
    }

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    if (Platform.isAndroid) {
      const AndroidId androidIdPlugin = AndroidId();
      deviceId = await androidIdPlugin.getId();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    final String? userId = userInfo?.userId;
    final String restoreId = userInfo?.restoreId ?? await getRestoreId() ?? '';
    final String? profileName = userInfo?.profileName;
    final String? email = userInfo?.email;

    try {
      FreshchatUser freshChatUser = FreshchatUser(userId, restoreId);
      if (profileName != null) {
        freshChatUser.setFirstName(profileName);
      }
      if (email != null) {
        freshChatUser.setEmail(email);
      }

      Freshchat.identifyUser(externalId: userId ?? '', restoreId: restoreId);
      Freshchat.setUser(freshChatUser);

      //Additional params
      var userPropertiesJson = {
        'user_id': userId,
        'device_id': deviceId,
        'app_name': appName,
        'role': 'advisor',
      };
      Freshchat.setUserProperties(userPropertiesJson);

      logger.d(
          'The user for Support page is - name:${freshChatUser.getFirstName()}'
          ', email:${freshChatUser.getEmail()}');

      return true;
    } catch (e) {
      logger.e('ERROR: FreshChatManager.setUpFreshChat: $e');
      return false;
    }
  }

  @override
  Stream onRestoreStream() {
    return Freshchat.onRestoreIdGenerated;
  }

  @override
  void changeLocaleInvite() {
    Freshchat.notifyAppLocaleChange();
  }

  @override
  Future<String?> getRestoreId() async {
    FreshchatUser user = await Freshchat.getUser;
    return user.getRestoreId();
  }
}

class FreshChaUserInfo {
  final String? userId;
  final String? restoreId;
  final String? profileName;
  final String? email;

  FreshChaUserInfo({
    this.userId,
    this.restoreId,
    this.profileName,
    this.email,
  });
}
