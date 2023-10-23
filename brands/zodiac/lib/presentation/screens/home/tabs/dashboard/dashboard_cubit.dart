import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final ZodiacCachingManager _cacheManager;
  final ZodiacMainCubit _mainCubit;
  final ConnectivityService _connectivityService;
  final ZodiacUserRepository _userRepository;

  late final StreamSubscription _userDetailsListener;
  late final StreamSubscription<UserBalance> _updateUserBalanceSubscription;

  final List<PaymentInformation> _transactionsListData = [];
  final int _limit = 20;
  int _offset = 0;
  int? _count;
  bool _isLoading = false;

  DashboardCubit(
    this._cacheManager,
    this._mainCubit,
    this._connectivityService,
    this._userRepository,
  ) : super(const DashboardState()) {
    _userDetailsListener = _cacheManager.listenDetailedUserInfo((value) {
      emit(state.copyWith(userPersonalInfo: value.details));
    });

    _updateUserBalanceSubscription =
        _mainCubit.userBalanceUpdateTrigger.listen((value) {
      emit(state.copyWith(userBalance: value));
    });

    getPaymentsList();
  }

  @override
  Future<void> close() async {
    _userDetailsListener.cancel();
    _updateUserBalanceSubscription.cancel();

    super.close();
  }

  Future<void> refreshDashboard() async {
    _mainCubit.updateAccount();
    getPaymentsList(refresh: true);
  }

  Future<void> getPaymentsList({bool refresh = false}) async {
    if (!refresh && _count != null && _offset >= _count!) {
      return;
    }

    if (!_isLoading) {
      if (refresh) {
        _transactionsListData.clear();
      }

      try {
        _isLoading = true;
        if (await _connectivityService.checkConnection()) {
          _offset = refresh ? 0 : _offset;
          final PaymentsListResponse response = await _userRepository
              .getPaymentsList(ListRequest(count: _limit, offset: _offset));

          _count = response.count ?? 0;
          _offset = _offset + _limit;

          _transactionsListData.addAll(response.result ?? []);
          final List<TransactionUiModel> transactionUiModelsList =
              await compute(TransactionUiModel.toTransactionUiModels,
                  _transactionsListData);

          emit(state.copyWith(
            transactionsList: transactionUiModelsList,
          ));
        }
      } catch (e) {
        logger.d(e);
      } finally {
        _isLoading = false;
        emit(state.copyWith(dataFetched: state.transactionsList != null));
      }
    }
  }
}
