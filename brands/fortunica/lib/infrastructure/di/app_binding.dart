import 'package:shared_advisor_interface/data/cache/global_caching_manager_impl.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager_impl.dart';
import 'inject_config.dart';

/// injecting app main dependencies so can be accessed from everywhere
class AppBinding {
  ///The starting point
  ///The order of the called function is important
  static Future<void> setupInjection(Flavor flavor, AppRouter navigationService) async {

    // fortunicaGetIt.registerSingleton<FortunicaCachingManager>(FortunicaCachingManagerImpl());
    // await fortunicaGetIt.get<FortunicaCachingManager>().openBoxes();

   await FortunicaCachingManagerImpl.openBoxes();
    ///injectable and get it configuration
   await configureDependenciesFortunica();

    //_injectFlavor(flavor);
    //await _injectNetworkingDependencies();
  }

  ///Calls [_injectDioForNetworking] prepares base URL
  static Future _injectNetworkingDependencies() async {
    //  final dio = await _injectDioForNetworking();
    final baseUrl = fortunicaGetIt.get<FlavorConfig>().baseUrl;

  }

  ///creating Dio instance to be injected later withing the services,
  /// and assign custom interceptor
  /// Note: order of interceptors matters
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

    ///Register the flavor with our get it
    fortunicaGetIt.registerSingleton(flavorConfig);
  }
}
