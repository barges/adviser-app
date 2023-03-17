import 'dart:io';

import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:hive/hive.dart';
import 'app_binding.dart';
import 'brand_manager.dart';

class AppInitializer {
  static Future setupPrerequisites(Flavor flavor) async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    if (Platform.isIOS) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: AppConstants.iosApiKey,
              appId: AppConstants.iosAppId,
              messagingSenderId: AppConstants.firebaseMessagingSenderId,
              projectId: AppConstants.firebaseProjectId));
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

    final navigationService = globalGetIt<AppRouter>();
    await globalGetIt<BrandManager>().initDi(flavor, navigationService);
  }
}
