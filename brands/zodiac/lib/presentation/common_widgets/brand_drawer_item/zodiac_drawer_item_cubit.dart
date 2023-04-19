import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/domain/repositories/zodiac_auth_repository.dart';
import 'package:zodiac/presentation/common_widgets/brand_drawer_item/zodiac_drawer_item_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac.dart';

class ZodiacDrawerItemCubit extends Cubit<ZodiacDrawerItemState> {
  final ZodiacAuthRepository _authRepository;
  final BrandManager _brandManager;

  final ZodiacCachingManager _zodiacCachingManager;
  final WebSocketManager _webSocketManager;

  // late final UserStatus? userStatus;

  ZodiacDrawerItemCubit(
    this._authRepository,
    this._brandManager,
    this._zodiacCachingManager,
    this._webSocketManager,
  ) : super(const ZodiacDrawerItemState()) {
    // userStatus = _fortunicaCachingManager.getUserStatus();
  }

  Future<void> logout(BuildContext context) async {
    final BaseResponse? response =
        await _authRepository.logout(request: AuthorizedRequest());
    if (response?.status == true) {
      _webSocketManager.close();
      await _zodiacCachingManager.logout();
      context.replaceAll([const ZodiacAuth()]);
    }
  }

  void changeCurrentBrand(BuildContext context) {
    _brandManager.setCurrentBrand(ZodiacBrand());
    context.pop();
  }
}
