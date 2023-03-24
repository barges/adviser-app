import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
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
  final ZodiacUserRepository _userRepository;

  late final StreamSubscription _userDetailsListener;
  late final StreamSubscription<UserBalance> _updateUserBalanceSubscription;

  List<PaymentInformation> _paymentsList = [];

  DashboardCubit(
    this._cacheManager,
    this._mainCubit,
    this._userRepository,
  ) : super(const DashboardState()) {
    getThisMonthPayments();

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

  Future<void> getThisMonthPayments() async {
    do {
      PaymentsListResponse response = await _userRepository.getPaymentsList(
        ListRequest(
          count: 20,
          offset: _paymentsList.length,
        ),
      );
      List<PaymentInformation>? paymentsList = response.result;

      _paymentsList.addAll(paymentsList ?? []);
    } while (_paymentsList.isNotEmpty &&
        _paymentsList.last.dateCreate != null &&
        _checkThisMonth(
              _paymentsList.last.dateCreate,
            ) ==
            true);

    if (_paymentsList.isNotEmpty) {
      List<PaymentInformation> resultList = List.of(
        _paymentsList
            .where((element) => _checkThisMonth(element.dateCreate) == true),
      );
      double thisMonthAmount = 0.0;
      for (PaymentInformation element in resultList) {
        thisMonthAmount += element.amount ?? 0.0;
      }
      emit(state.copyWith(monthAmount: thisMonthAmount));
    } else {
      emit(state.copyWith(monthAmount: 0.0));
    }
  }

  bool? _checkThisMonth(int? dateCreate) {
    if (dateCreate != null) {
      final DateTime now = DateTime.now();
      final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(dateCreate * 1000);
      return date.year == now.year && date.month == now.month;
    } else {
      return null;
    }
  }
}
