import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';

class Utils{
 static void changeLocale(int index) {
    final Locale locale = S.delegate.supportedLocales[index];
    Get.updateLocale(
        Locale(locale.languageCode, locale.languageCode.toUpperCase()));
    if (Platform.isAndroid) {
      Get.find<FreshChatService>().changeLocaleInvite();
    }
    Get.find<CachingManager>().saveLocaleIndex(index);
  }
}