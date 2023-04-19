import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_state.dart';

///Home Cubit that will have the repo and all the requests
class MainHomeScreenCubit extends Cubit<MainHomeScreenState> {
  final BrandManager _brandManager;

  late final List<BaseBrand> brands;
  late final List<PageRouteInfo> routes;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  MainHomeScreenCubit(this._brandManager) : super(const MainHomeScreenState()) {
    final BaseBrand currentBrand = _brandManager.getCurrentBrand();

    brands = BrandManager.getActiveBrandsWithFirstCurrent(currentBrand);

    routes = brands.map((e) => e.initRoute).toList();

    if (!brands.first.isAuth) {
      final BaseBrand? brand = brands.firstWhereOrNull((e) => e.isAuth);
      if (brand != null) {
        _brandManager.setCurrentBrand(brand);
      }
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
