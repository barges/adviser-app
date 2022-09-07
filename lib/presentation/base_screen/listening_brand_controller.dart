import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';

abstract class ListeningBrandController extends GetxController {
  final CacheManager cacheManager;

  final Rx<Brand?> currentBrand = Brand.fortunica.obs;

  ListeningBrandController(this.cacheManager);

  @override
  void onInit() {
    super.onInit();
    currentBrand.value = cacheManager.getCurrentBrand() ?? Brand.fortunica;
    cacheManager.listenCurrentBrand((value) {
      currentBrand.value = value;
    });
  }
}
