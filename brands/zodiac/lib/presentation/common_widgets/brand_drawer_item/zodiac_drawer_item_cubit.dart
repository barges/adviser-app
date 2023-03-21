import 'dart:async';

import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/websocket_manager/websocket_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_auth_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/brand_drawer_item/zodiac_drawer_item_state.dart';

class ZodiacDrawerItemCubit extends Cubit<ZodiacDrawerItemState> {
  final ZodiacAuthRepository _authRepository;
  final GlobalCachingManager _globalCachingManager;

  final ZodiacCachingManager _zodiacCachingManager;
  final WebSocketManager _webSocketManager;

  final router = zodiacGetIt.get<AppRouter>();

  // late final UserStatus? userStatus;

  ZodiacDrawerItemCubit(
    this._authRepository,
    this._globalCachingManager,
    this._zodiacCachingManager,
    this._webSocketManager,
  ) : super(const ZodiacDrawerItemState()) {
    // userStatus = _fortunicaCachingManager.getUserStatus();
  }

  Future<void> logout(BuildContext context) async {
    final BaseResponse? response = await _authRepository.logout(request: AuthorizedRequest());
    if(response?.status == true) {
      logger.d('CLOSE');
      _webSocketManager.close();
      await _zodiacCachingManager.logout();
      router.replaceAll(context, [const ZodiacAuth()]);
    }
  }

  void changeCurrentBrand(BuildContext context) {
    _globalCachingManager.saveCurrentBrand(Brand.zodiac);
    router.pop(context);
  }
}
