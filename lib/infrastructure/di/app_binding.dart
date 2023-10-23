import 'dart:developer';

import '../../data/cache/fortunica_caching_manager_impl.dart';
import '../../global.dart';
import '../flavor/flavor_config.dart';
import '../routing/app_router.gr.dart';
import 'inject_config.dart';

class AppBinding {
  static Future<void> setupInjection(Flavor flavor) async {
    globalGetIt.registerSingleton(MainAppRouter());
    await FortunicaCachingManagerImpl.openBoxes();
    await configureDependenciesFortunica();
  }

  static Future _injectNetworkingDependencies() async {
    //  final dio = await _injectDioForNetworking();
    final baseUrl = globalGetIt.get<FlavorConfig>().baseUrl;
    log("BaseUrl from inject: $baseUrl");
  }

  // static Future<Dio> _injectDioForNetworking() async {
  //   final dio = Dio();
  //
  //   ///attach app's interceptor
  //   dio.interceptors.add(AppInterceptor());
  //
  //   getIt.registerSingleton(dio);
  //
  //   return dio;
  // }

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

    globalGetIt.registerSingleton(flavorConfig);

    ///Register the flavor with our get it
    globalGetIt.registerSingleton(flavorConfig);
  }
}
