import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Home Cubit that will have the repo and all the requests
class MainHomeScreenCubit extends Cubit<MainHomeScreenState> {
  final GlobalCachingManager _globalCachingManager;

  late final List<Brand> brands;
  late final List<PageRouteInfo> routes;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PublishSubject<bool> articleCountUpdateTrigger = PublishSubject();

  MainHomeScreenCubit(this._globalCachingManager)
      : super(const MainHomeScreenState()) {
    final Brand currentBrand = _globalCachingManager.getCurrentBrand();

    brands = Configuration.getBrandsWithFirstCurrent(currentBrand);

    routes = brands.map((e) => getPage(e)).toList();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  PageRouteInfo getPage(Brand brand) {
    switch (brand) {
      case Brand.fortunica:
        return const Fortunica();
      case Brand.zodiac:
        return const Zodiac();
    }
  }

  void updateArticleCount() {
    articleCountUpdateTrigger.add(true);
  }
}
