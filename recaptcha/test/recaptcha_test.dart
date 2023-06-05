/*import 'package:flutter_test/flutter_test.dart';
import 'package:recaptcha/recaptcha.dart';
import 'package:recaptcha/recaptcha_platform_interface.dart';
import 'package:recaptcha/recaptcha_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRecaptchaPlatform
    with MockPlatformInterfaceMixin
    implements RecaptchaPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RecaptchaPlatform initialPlatform = RecaptchaPlatform.instance;

  test('$MethodChannelRecaptcha is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRecaptcha>());
  });

  test('getPlatformVersion', () async {
    Recaptcha recaptchaPlugin = Recaptcha();
    MockRecaptchaPlatform fakePlatform = MockRecaptchaPlatform();
    RecaptchaPlatform.instance = fakePlatform;

    expect(await recaptchaPlugin.getPlatformVersion(), '42');
  });
}*/
