import 'dart:async';

import 'package:flutter/services.dart';
import 'package:recaptcha/recaptcha_enterprise.dart';
import 'package:zodiac/data/models/enums/recaptcha_custom_action.dart';
import 'package:zodiac/services/recaptcha/recaptcha_error.dart';

class RecaptchaService {
  RecaptchaService._();

  static Completer<bool> _completer = Completer<bool>()..complete(false);

  static Future<void> init(String siteKey) async {
    if (!await isInitialized()) {
      _completer = Completer<bool>();
      try {
        await RecaptchaEnterprise.init(siteKey);
        _completer.complete(true);
      } on PlatformException catch (e) {
        _completer.complete(false);
        throw RecaptchaError(
          code: e.code,
          message: e.message,
          details: e.details,
        );
      }
    }
  }

  static Future<String> execute(
      RecaptchaCustomAction recaptchaCustomAction) async {
    return await RecaptchaEnterprise.execute(recaptchaCustomAction.toString());
  }

  static Future<bool> isInitialized() {
    return _completer.future;
  }
}
