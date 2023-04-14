import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';

part 'transaction_ui_model.freezed.dart';

@freezed
class TransactionUiModel with _$TransactionUiModel {
  const factory TransactionUiModel.data(List<PaymentInformation> items) = Data;
  const factory TransactionUiModel.separator(DateTime? item) = Separator;
}
