// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_information.g.dart';
part 'payment_information.freezed.dart';

@freezed
class PaymentInformation with _$PaymentInformation {
  const PaymentInformation._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory PaymentInformation({
    int? id,
    int? dateCreate,
    int? source,
    double? fee,
    double? amount,
    int? length,
    String? note,
    String? avatar,
  }) = _PaymentInformation;

  factory PaymentInformation.fromJson(Map<String, dynamic> json) =>
      _$PaymentInformationFromJson(json);
}
