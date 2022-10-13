import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';

part 'balance_and_transactions_state.freezed.dart';

@freezed
class BalanceAndTransactionsState with _$BalanceAndTransactionsState {
  const factory BalanceAndTransactionsState({
    @Default([]) List<ReportsMonth> months,
    @Default(0) int currentMonthIndex,
  }) = _BalanceAndTransactionsState;
}
