import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_advisor_interface/data/cache/secure_storage_manager.dart';
import 'package:shared_advisor_interface/global.dart';

class AppInfo {
  late final Future<bool> _initAppInfo;
  static String? deviceId;
  static String? device;
  static late final String secret;
  static late final String package;
  static late final String version;
  static late final String locale;
  static late final String deviceType;
  static late final String os;
  static late final String appsflyerId;
  static final AppInfo _instance = AppInfo._internal();

  AppInfo._internal() {
    _initAppInfo = Future<bool>(() async {
      await _init();
      return true;
    });
  }

  static Future<bool> init() {
    return AppInfo()._initAppInfo;
  }

  factory AppInfo() {
    return _instance;
  }

  Future<void> _init() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    secret = '23d45b337ff85d0a326a79082f7c6f50';

    ///TODO: Need change on backend
    package = packageInfo.packageName;
    version = '5.6';
    locale = Intl.getCurrentLocale();
    appsflyerId = '1469200336473-6162102739781632588';

    SecureStorageManager secureStorageManager =
        globalGetIt.get<SecureStorageManager>();
    deviceId = await secureStorageManager.getDeviceId();
    if (Platform.isAndroid) {
      const AndroidId androidIdPlugin = AndroidId();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (deviceId == null) {
        deviceId = await androidIdPlugin.getId();
        secureStorageManager.saveDeviceId(deviceId!);
      }
      device = "${androidInfo.manufacturer} ${androidInfo.model}";
      deviceType = 'android';
      os = 'android';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (deviceId == null) {
        deviceId = iosInfo.identifierForVendor;
        secureStorageManager.saveDeviceId(deviceId!);
      }
      device = iosInfo.name;
      deviceType = 'iphone';
      os = 'iphone';
    }
  }
}
