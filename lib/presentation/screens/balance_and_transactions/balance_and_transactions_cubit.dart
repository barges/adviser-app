import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_year.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_state.dart';

class BalanceAndTransactionsCubit extends Cubit<BalanceAndTransactionsState> {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final MainCubit mainCubit = Get.find<MainCubit>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  BalanceAndTransactionsCubit() : super(const BalanceAndTransactionsState()) {
    getReports();
  }

  Future<void> getReports() async {
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

  String currencySymbolByName(String currencyName) {
    final NumberFormat format = NumberFormat.simpleCurrency(name: currencyName);
    return format.currencySymbol;
  }
}
