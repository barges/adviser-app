import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_year.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_state.dart';

class BalanceAndTransactionsCubit extends Cubit<BalanceAndTransactionsState> {
  final UserRepository _userRepository = getIt.get<UserRepository>();
  final MainCubit mainCubit = getIt.get<MainCubit>();
  final CachingManager _cacheManager = getIt.get<CachingManager>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late final VoidCallback _disposeUserIdListen;

  String? userId;

  BalanceAndTransactionsCubit() : super(const BalanceAndTransactionsState()) {
    userId = _cacheManager.getUserId();

    getReports();

    _disposeUserIdListen = _cacheManager.listenUserId((value) {
      if (value != null) {
        userId = value;
        getReports();
      }
    });
  }

  @override
  Future<void> close() async {
    _disposeUserIdListen.call();

    super.close();
  }

  Future<void> getReports() async {
    try {
      if (userId == null) {
        mainCubit.updateAccount();
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

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
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
