import 'dart:developer';

import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/data/app_info.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager_impl.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';

/// injecting app main dependencies so can be accessed from everywhere
class AppBinding {
  ///The starting point
  ///The order of the called function is important
  static Future<void> setupInjection(
      Flavor flavor, AppRouter navigationService) async {
    ///injectable and get it configuration
    await ZodiacCachingManagerImpl.openBoxes();
    await configureDependenciesZodiac();
    await AppInfo.init();
    // _injectFlavor(flavor);
    // await _injectNetworkingDependencies();
    //_injectNavigation(navigationService);
  }

  ///Calls [_injectDioForNetworking] prepares base URL
  static Future _injectNetworkingDependencies() async {
    //  final dio = await _injectDioForNetworking();
    final baseUrl = globalGetIt.get<FlavorConfig>().baseUrl;
    log("BaseUrl from inject: $baseUrl");
  }

  static _injectNavigation(AppRouter navigationService) {
    zodiacGetIt.registerSingleton(navigationService, instanceName: 'fortunica');
  }

  ///prepare flavor config depending on the selected passed [flavor]
  static void _injectFlavor(Flavor flavor) {
    FlavorConfig flavorConfig;
    switch (flavor) {
      case Flavor.dev:
        flavorConfig = FlavorConfig(
            flavor: Flavor.dev, baseUrl: 'https://dev.url.com/api');
        break;
      case Flavor.beta:
        flavorConfig = FlavorConfig(
            flavor: Flavor.beta, baseUrl: 'https://beta.url.com/api');
        break;
      case Flavor.production:
        flavorConfig = FlavorConfig(
            flavor: Flavor.production, baseUrl: 'https://url.com/api');

        break;
    }

    ///Register the flavor with our get it
    zodiacGetIt.registerSingleton(flavorConfig);
  }
}
