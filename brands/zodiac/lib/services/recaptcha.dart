import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/enums/recaptcha_custom_action.dart';
import 'package:zodiac/pigeons/recaptcha_api.dart';

class Recaptcha {
  Recaptcha._();

  static final RecaptchaApi _recaptchaApi = RecaptchaApi();
  static Future<bool> _initRecaptcha = Future.value(false);

  static Future<bool> init(String siteKey) async {
    if (!await _initRecaptcha) {
      _tryInit(siteKey);
    }
    return _initRecaptcha;
  }

  Future<String> execute(RecaptchaCustomAction recaptchaCustomAction) async {
    return await _recaptchaApi.execute(recaptchaCustomAction.toString());
  }

  static Future<bool> isInitialized() {
    return _initRecaptcha;
  }

  static Future<void> _tryInit(String siteKey) async {
    print('!!!!! _tryInit');
    _initRecaptcha = Future<bool>(() async {
      try {
        await _init(siteKey);
        return true;
      } catch (e) {
        logger.d(e);
      }
      return false;
    });
  }

  static Future<void> _init(String siteKey) async {
    await _recaptchaApi.initialize(siteKey);
  }
}
