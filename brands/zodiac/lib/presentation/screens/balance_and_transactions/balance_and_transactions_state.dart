import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';

part 'balance_and_transactions_state.freezed.dart';

@freezed
class BalanceAndTransactionsState with _$BalanceAndTransactionsState {
  const factory BalanceAndTransactionsState({
    UserBalance? userBalance,
    List<TransactionUiModel>? transactionsList,
    @Default(false) bool isVisibleUpButton,
    DateTime? dateCreate,
    double? appBarHeight,
  }) = _BalanceAndTransactionsState;
}
