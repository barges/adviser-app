import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../data/models/reports_endpoint/reports_month.dart';
import '../../../data/models/reports_endpoint/reports_statistics.dart';
import '../../../data/models/reports_endpoint/reports_year.dart';
import '../../../data/network/responses/reports_response.dart';
import '../../../domain/repositories/fortunica_user_repository.dart';
import '../../../global.dart';
import '../../../main_cubit.dart';
import 'balance_and_transactions_state.dart';

@injectable
class BalanceAndTransactionsCubit extends Cubit<BalanceAndTransactionsState> {
  final FortunicaCachingManager _cacheManager;
  final FortunicaUserRepository _userRepository;
  final MainCubit _mainCubit;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late final StreamSubscription _userIdSubscription;

  String? userId;

  BalanceAndTransactionsCubit(
      this._cacheManager, this._userRepository, this._mainCubit)
      : super(const BalanceAndTransactionsState()) {
    userId = _cacheManager.getUserId();

    getReports();

    _userIdSubscription = _cacheManager.listenUserIdStream((value) {
      if (value != null) {
        userId = value;
        getReports();
      }
    });
  }

  @override
  Future<void> close() async {
    _userIdSubscription.cancel();

    super.close();
  }

  Future<void> getReports() async {
    try {
      if (userId == null) {
        _mainCubit.updateAccount();
      }
      if (userId != null) {
        final List<ReportsMonth> months = [];
        final ReportsResponse reportsResponse =
            await _userRepository.getUserReports();

        for (ReportsYear year in reportsResponse.dateRange ?? []) {
          months.addAll(year.months ?? []);
        }

        emit(
          state.copyWith(
            months: months,
            reportsStatistics: months.firstOrNull?.statistics,
          ),
        );
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> updateStatisticsByMonth(int index) async {
    if (index > 0) {
      final ReportsStatistics reportsStatistics =
          await _userRepository.getUserReportsByMonth(
        state.months[index].startDate ?? '',
        state.months[index].endDate ?? '',
      );

      emit(state.copyWith(reportsStatistics: reportsStatistics));
    } else {
      emit(state.copyWith(
        reportsStatistics: state.months.firstOrNull?.statistics,
      ));
    }
  }

  void updateCurrentMonthIndex(int index) {
    emit(state.copyWith(currentMonthIndex: index));
    updateStatisticsByMonth(index);
  }
}
