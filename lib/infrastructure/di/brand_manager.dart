import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_router.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

class BrandManager with ChangeNotifier {
  List<Brand> list = [];
  // late RootStackRouter mainRouter;
  // late BrandRouterManager brandRouterManager;

  BrandManager(this.list, projectRouter);
  //{
    //brandRouterManager = BrandRouterManager(projectRouter);

    // for (Brand brand in list) {
    //   brandRouterManager.add(brand);
    //   // brand.addListener(notifyListeners);
    // }

    //mainRouter = brandRouterManager.getRouter();
  // }

  initDi(Flavor flavor, AppRouter navigationService) async {
    for (Brand brand in list) {
      await brand.init(flavor, navigationService);
    }
  }

  // List<Brand> getActiveBrand() {
  //   return list.where((element) => element.isEnabled).toList();
  // }

  // RootStackRouter get router => mainRouter;
}