import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retrofit/dio.dart';

import '../../../infrastructure/routing/app_router.dart';
import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../domain/repositories/fortunica_auth_repository.dart';
import '../../../infrastructure/routing/app_router.gr.dart';
import '../../../main_cubit.dart';
import 'fortunica_drawer_item_state.dart';

class FortunicaDrawerItemCubit extends Cubit<FortunicaDrawerItemState> {
  final FortunicaAuthRepository _authRepository;
  final FortunicaCachingManager _fortunicaCachingManager;
  final MainCubit _mainCubit;

  FortunicaDrawerItemCubit(
    this._authRepository,
    this._fortunicaCachingManager,
    this._mainCubit,
  ) : super(const FortunicaDrawerItemState());

  Future<void> logout(BuildContext context) async {
    final HttpResponse response = await _authRepository.logout();
    if (response.response.statusCode == 200) {
      await _fortunicaCachingManager.logout();
      _mainCubit.updateAuth(false);
      // ignore: use_build_context_synchronously
      context.replaceAll([const FortunicaLogin()]);
    }
  }
}
