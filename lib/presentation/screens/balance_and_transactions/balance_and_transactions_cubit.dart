import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_year.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_state.dart';

class BalanceAndTransactionsCubit extends Cubit<BalanceAndTransactionsState> {
  final UserRepository _userRepository = Get.find<UserRepository>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  BalanceAndTransactionsCubit() : super(const BalanceAndTransactionsState()) {
    getReports();
  }

  Future<void> getReports() async {
    final ReportsResponse reportsResponse =
        await _userRepository.getUserReports();

    final List<ReportsMonth> months = [];

    for (ReportsYear year in reportsResponse.dateRange ?? []) {
      months.addAll(year.months ?? []);
    }

    emit(state.copyWith(months: months));
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void updateCurrentMonthIndex(int index) {
    emit(state.copyWith(currentMonthIndex: index));
  }
}
