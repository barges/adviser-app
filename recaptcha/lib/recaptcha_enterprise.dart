import 'package:recaptcha/recaptcha_api.dart';

class RecaptchaEnterprise {
  static final _recaptchaApi = RecaptchaApi();
  RecaptchaEnterprise._();

  static Future<String> init(String siteKey) {
    return _recaptchaApi.initialize(siteKey);
  }

  static Future<String> execute(String action) {
    return _recaptchaApi.execute(action);
  }
}
