import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ZodiacCachingManager _cacheManager;
  final ZodiacMainCubit _mainCubit;

  late final StreamSubscription _userDetailsListener;
  late final StreamSubscription<UserBalance> _updateUserBalanceSubscription;

  DashboardCubit(
    this._cacheManager,
    this._mainCubit,
  ) : super(const DashboardState()) {

    _userDetailsListener = _cacheManager.listenDetailedUserInfo((value) {
      emit(state.copyWith(userPersonalInfo: value.details));
    });
    _updateUserBalanceSubscription =
        _mainCubit.userBalanceUpdateTrigger.listen((value) {
      emit(state.copyWith(userBalance: value));
    });
  }

  @override
  Future<void> close() async {
    _userDetailsListener.cancel();
    _updateUserBalanceSubscription.cancel();

    super.close();
  }

  Future<void> refreshDashboard() async {
    _mainCubit.updateAccount();
  }
}
