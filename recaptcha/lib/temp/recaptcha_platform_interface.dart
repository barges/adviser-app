/*import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'recaptcha_method_channel.dart';

abstract class RecaptchaPlatform extends PlatformInterface {
  /// Constructs a RecaptchaPlatform.
  RecaptchaPlatform() : super(token: _token);

  static final Object _token = Object();

  static RecaptchaPlatform _instance = MethodChannelRecaptcha();

  /// The default instance of [RecaptchaPlatform] to use.
  ///
  /// Defaults to [MethodChannelRecaptcha].
  static RecaptchaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RecaptchaPlatform] when
  /// they register themselves.
  static set instance(RecaptchaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}*/
