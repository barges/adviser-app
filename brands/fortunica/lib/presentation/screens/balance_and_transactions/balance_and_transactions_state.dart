import 'package:fortunica/data/models/reports_endpoint/reports_month.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_statistics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_and_transactions_state.freezed.dart';

@freezed
class BalanceAndTransactionsState with _$BalanceAndTransactionsState {
  const factory BalanceAndTransactionsState({
    @Default([]) List<ReportsMonth> months,
    @Default(0) int currentMonthIndex,
    @Default(ReportsStatistics()) ReportsStatistics? reportsStatistics,
  }) = _BalanceAndTransactionsState;
}