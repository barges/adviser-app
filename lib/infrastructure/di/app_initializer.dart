import 'dart:io';

import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:hive/hive.dart';
import 'package:system_date_time_format/system_date_time_format.dart';
import 'app_binding.dart';
import 'brand_manager.dart';

class AppInitializer {
  static Future setupPrerequisites(Flavor flavor) async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    final format = SystemDateTimeFormat();

    final String? timePattern = await format.getTimePattern();

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    if (Platform.isIOS) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: AppConstants.iosApiKey,
          appId: AppConstants.iosAppId,
          messagingSenderId: AppConstants.firebaseMessagingSenderId,
          projectId: AppConstants.firebaseProjectId,
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return true;
    };

    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    ///dependencies injection
    await AppBinding.setupInjection(flavor);

    if (timePattern != null) {
      BrandManager.timeFormat = timePattern;
    }

    await globalGetIt<BrandManager>().initDi(flavor);
  }
}
