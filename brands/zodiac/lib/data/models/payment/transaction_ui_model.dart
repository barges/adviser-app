import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';

part 'transaction_ui_model.freezed.dart';

@freezed
class TransactionUiModel with _$TransactionUiModel {
  const factory TransactionUiModel.data(List<PaymentInformation> items) = Data;
  const factory TransactionUiModel.separator(DateTime? item) = Separator;

  static List<TransactionUiModel> toTransactionUiModels(
      List<PaymentInformation> data) {
    final uiModelItems = <TransactionUiModel>[];
    DateTime? dateCreate;
    List<PaymentInformation> items = [];
    for (var item in data) {
      if (item.dateCreate == null) continue;

      if (dateCreate?.day != item.dateCreate?.day ||
          dateCreate?.month != item.dateCreate?.month ||
          dateCreate?.year != item.dateCreate?.year) {
        items = [];
        dateCreate = item.dateCreate;
        uiModelItems.add(TransactionUiModel.separator(dateCreate));
        uiModelItems.add(TransactionUiModel.data(items));
      }
      items.add(item);
    }
    return uiModelItems;
  }
}
