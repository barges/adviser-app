import 'package:flutter/services.dart';
import 'package:zodiac/data/models/enums/recaptcha_error_code.dart';

class RecaptchaError extends PlatformException {
  final RecaptchaErrorCode? recaptchaErrorCode;
  RecaptchaError({
    required super.code,
    super.message,
    super.details,
    this.recaptchaErrorCode,
  });

  @override
  String toString() =>
      'RecaptchaError($code, $message, $details, $stacktrace, $recaptchaErrorCode)';
}
