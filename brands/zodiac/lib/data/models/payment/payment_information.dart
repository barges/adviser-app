// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/payment_source.dart';

part 'payment_information.g.dart';
part 'payment_information.freezed.dart';

@freezed
class PaymentInformation with _$PaymentInformation {
  const PaymentInformation._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory PaymentInformation({
    int? id,
    @JsonKey(fromJson: _toDateTime) DateTime? dateCreate,
    @JsonKey(fromJson: _sourceFromJson)
    @Default(PaymentSource.none)
        PaymentSource source,
    double? fee,
    double? amount,
    @JsonKey(fromJson: _toDuration) Duration? length,
    String? note,
    String? avatar,
  }) = _PaymentInformation;

  factory PaymentInformation.fromJson(Map<String, dynamic> json) =>
      _$PaymentInformationFromJson(json);
}

DateTime? _toDateTime(int? value) =>
    value != null ? DateTime.fromMillisecondsSinceEpoch(value * 1000) : null;

PaymentSource _sourceFromJson(int? value) {
  return PaymentSource.fromInt(value);
}

Duration? _toDuration(int? value) =>
    value != null ? Duration(seconds: value) : null;
