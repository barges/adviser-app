import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';

///Home Cubit that will have the repo and all the requests
class MainHomeScreenCubit extends Cubit<MainHomeScreenState> {
  final GlobalCachingManager _globalCachingManager;

  late final List<BaseBrand> brands;
  late final List<PageRouteInfo> routes;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  MainHomeScreenCubit(this._globalCachingManager)
      : super(const MainHomeScreenState()) {
    final BaseBrand currentBrand = _globalCachingManager.getCurrentBrand();

    brands = BrandManager.getActiveBrandsWithFirstCurrent(currentBrand);

    routes = brands.map((e) => e.initRoute).toList();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
