/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/cache/fortunica_caching_manager.dart';
import '../../../../fortunica_main_cubit.dart';
import 'main_home_screen_state.dart';

///Home Cubit that will have the repo and all the requests
class MainHomeScreenCubit extends Cubit<MainHomeScreenState> {
  //final FortunicaMainCubit fortunicaMainCubit;
  final FortunicaCachingManager cachingManager;

  // TODO DELETE
  //final BrandManager _brandManager;

  //late final List<BaseBrand> brands;
  //late final List<PageRouteInfo> routes;

  late final StreamSubscription<bool> _updateAuthSubscription;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  MainHomeScreenCubit({
    required this.fortunicaMainCubit,
    required this.cachingManager,
  }) : super(const MainHomeScreenState()) {
    emit(state.copyWith(isAuth: cachingManager.isAuth));
    /*_updateAuthSubscription = fortunicaMainCubit.updateAuthTrigger.listen(
      (value) {
        emit(state.copyWith(isAuth: value));
      },
    );*/

    // TODO DELETE
    //final BaseBrand currentBrand = _brandManager.getCurrentBrand();

    //brands = BrandManager.getActiveBrandsWithFirstCurrent(currentBrand);

    //routes = //brands.map((e) => e.initRoute).toList();

    /*if (!brands.first.isAuth) {
      final BaseBrand? brand = brands.firstWhereOrNull((e) => e.isAuth);
      if (brand != null) {
        //_brandManager.setCurrentBrand(brand);
      }
    }*/
  }

  @override
  Future<void> close() async {
    _updateAuthSubscription.cancel();
    return super.close();
  }

  /*void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }*/
}*/
