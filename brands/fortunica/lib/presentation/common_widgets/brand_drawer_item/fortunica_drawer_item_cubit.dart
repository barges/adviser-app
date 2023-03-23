import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/user_info/user_status.dart';
import 'package:fortunica/domain/repositories/fortunica_auth_repository.dart';
import 'package:fortunica/fortunica.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/brand_drawer_item/fortunica_drawer_item_state.dart';
import 'package:retrofit/dio.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';

class FortunicaDrawerItemCubit extends Cubit<FortunicaDrawerItemState> {
  final FortunicaAuthRepository _authRepository;
  final GlobalCachingManager _globalCachingManager;
  final FortunicaCachingManager _fortunicaCachingManager;

  final router = fortunicaGetIt.get<AppRouter>();

  late final UserStatus? userStatus;

  FortunicaDrawerItemCubit(
    this._authRepository,
    this._globalCachingManager,
    this._fortunicaCachingManager,
  ) : super(const FortunicaDrawerItemState()) {
    userStatus = _fortunicaCachingManager.getUserStatus();
  }

  Future<void> logout(BuildContext context) async {
    final HttpResponse response = await _authRepository.logout();
    if (response.response.statusCode == 200) {
      await _fortunicaCachingManager.logout();
        context.replaceAll([FortunicaAuth()]);
    }
  }

  void changeCurrentBrand(BuildContext context) {
    _globalCachingManager.saveCurrentBrand(FortunicaBrand());
    router.pop(context);
  }
}
