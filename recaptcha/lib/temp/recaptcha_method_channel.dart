/*import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'recaptcha_platform_interface.dart';

/// An implementation of [RecaptchaPlatform] that uses method channels.
class MethodChannelRecaptcha extends RecaptchaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('recaptcha');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}*/
