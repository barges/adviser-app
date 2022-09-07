import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_controller.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_controller.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final CacheManager cacheManager = Get.find<CacheManager>();
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DashboardController>(() => DashboardController(cacheManager));
    Get.lazyPut<AppDrawerController>(() => AppDrawerController(cacheManager));
  }
}
