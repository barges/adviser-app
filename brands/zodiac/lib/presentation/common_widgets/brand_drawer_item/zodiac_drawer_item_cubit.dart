import 'dart:async';

import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/brand_drawer_item/zodiac_drawer_item_state.dart';

class ZodiacDrawerItemCubit extends Cubit<ZodiacDrawerItemState> {
  //final FortunicaAuthRepository _authRepository;
  final GlobalCachingManager _globalCachingManager;

  final ZodiacCachingManager _zodiacCachingManager;

  final router = zodiacGetIt.get<AppRouter>();

  // late final UserStatus? userStatus;

  ZodiacDrawerItemCubit(
    //this._authRepository,
    this._globalCachingManager,
    this._zodiacCachingManager,
    // this._fortunicaCachingManager,
  ) : super(const ZodiacDrawerItemState()) {
    // userStatus = _fortunicaCachingManager.getUserStatus();
  }

  Future<void> logout(BuildContext context) async {
    await _zodiacCachingManager.logout();
    // await _zodiacCachingManager.logout();
    router.replaceAll(context, [const ZodiacAuth()]);
  }

  void changeCurrentBrand(BuildContext context) {
    _globalCachingManager.saveCurrentBrand(Brand.zodiac);
    router.pop(context);
  }
}
