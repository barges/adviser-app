import 'dart:io';

import 'package:shared_advisor_interface/global.dart';
import 'package:collection/collection.dart';
import 'package:fortunica/data/models/user_info/user_info.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:injectable/injectable.dart';


const String appName = 'Psychic Union';

abstract class FreshChatService {
  Future<bool> setUpFortunicaFreshChat(UserInfo? userInfo);

  Future<void> initFreshChat(bool isDarkMode);

  Stream onRestoreStream();

  Future<String?> getRestoreId();

  List<String> categoriesByLocale(String languageCode);

  List<String> tagsByLocale(String languageCode);

  void changeLocaleInvite();
}

@Singleton(as: FreshChatService)
class FreshChatServiceImpl extends FreshChatService {
  static const String freshChatId = 'ad263ea2-8218-4618-88bd-220ab8d56e23';
  static const String freshChatKey = 'd77300c3-b490-46f6-86d9-226b4e79c737';
  static const String freshChatDomain = 'msdk.freshchat.com';
  bool _wasInit = false;


  @override
  Future initFreshChat(bool isDarkMode) async {
    Freshchat.init(freshChatId, freshChatKey, freshChatDomain,
        stringsBundle: 'FCCustomLocalizable',
        themeName: isDarkMode ? 'FCDarkTheme.plist' : 'FCTheme.plist');
    _wasInit = true;
  }

  @override
  Future<bool> setUpFortunicaFreshChat(UserInfo? userInfo) async {
    if (!_wasInit) {
      throw Exception([
        'Fresh Chat Manager was not init. Pleas use initFreshChat() before setUpFreshChat.'
      ]);
    }
    final String userId = userInfo?.id ?? '';
    final String? restoreId = userInfo?.freshchatInfo?.restoreId;

    try {
      FreshchatUser freshChatUser = FreshchatUser(userId, restoreId);
      freshChatUser.setFirstName(userInfo?.profile?.profileName ?? '');
      freshChatUser.setEmail(userInfo?.emails?.firstOrNull?.address ?? '');
      Freshchat.identifyUser(externalId: userId, restoreId: restoreId);
      Freshchat.setUser(freshChatUser);

      //Additional params
      var userPropertiesJson = {
        'user_id': userId,
        //"device_id": _apiConfig.deviceInfo().deviceId,
        'app_name': appName
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
  List<String> categoriesByLocale(String languageCode) {
    logger.d(Platform.localeName);
    List<String> categories = [
      'general_foen_advisor',
      'payments_foen_advisor',
      'offers_foen_advisor',
      'tips_foen_advisor',
      'techhelp_foen_advisor',
      'performance_foen_advisor',
      'webtool_foen_advisor',
    ];
    switch (languageCode) {
      case 'de':
        categories = [
          'general_fode_advisor',
          'payments_fode_advisor',
          'offers_fode_advisor',
          'tips_fode_advisor',
          'techhelp_fode_advisor',
          'performance_fode_advisor',
        ];
        break;

      case 'es':
        categories = [
          'general_foes_advisor',
          'payments_foes_advisor',
          'webtool_foes_advisor',
          'tips_foes_advisor',
          'performance_foes_advisor',
          'specialcases_foes_advisor',
        ];
        break;
      case 'pt':
        categories = [
          'general_fopt_advisor',
          'payments_fopt_advisor',
          'offers_fopt_advisor',
          'tips_fopt_advisor',
          'techhelp_fopt_advisor',
        ];
        break;
      case 'en':
      default:
    }
    return categories;
  }

  @override
  List<String> tagsByLocale(String languageCode) {
    logger.d(languageCode);
    List<String> tags = [
      'foen',
    ];
    switch (languageCode) {
      case 'de':
        tags = [
          'fode',
        ];
        break;

      case 'es':
        tags = [
          'foes',
        ];
        break;
      case 'pt':
        tags = [
          'fopt',
        ];
        break;
      case 'en':
      default:
    }
    return tags;
  }

  @override
  Future<String?> getRestoreId() async {
    FreshchatUser user = await Freshchat.getUser;
    return user.getRestoreId();
  }
}
