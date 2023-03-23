import 'package:fortunica/fortunica.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/zodiac.dart';

///Home Cubit that will have the repo and all the requests
class MainHomeScreenCubit extends Cubit<MainHomeScreenState> {
  final GlobalCachingManager _globalCachingManager;

  late final List<BaseBrand> brands;
  late final List<PageRouteInfo> routes;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  MainHomeScreenCubit(this._globalCachingManager)
      : super(const MainHomeScreenState()) {
    final BaseBrand currentBrand = _globalCachingManager.getCurrentBrand();

    brands = BrandManager.getBrandsWithFirstCurrent(currentBrand.brandAlias);

    routes = brands.map((e) => getPage(e.brandAlias)).toList();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  PageRouteInfo getPage(String brandAlias) {
    switch (brandAlias) {
      case FortunicaBrand.alias:
        return const Fortunica();
      case ZodiacBrand.alias:
        return const Zodiac();
      default:
        return const Fortunica();
    }
  }
}
