// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/zodiac_extensions.dart';

part 'user_balance.freezed.dart';
part 'user_balance.g.dart';

@freezed
class UserBalance with _$UserBalance {
  const UserBalance._();

  @JsonSerializable(includeIfNull: false, createToJson: true)
  const factory UserBalance({
    double? balance,
    String? currency,
  }) = _UserBalance;

  factory UserBalance.fromJson(Map<String, dynamic> json) =>
      _$UserBalanceFromJson(json);

  @override
  String toString() {
    return balance != null ? balance!.toCurrencyFormat(currency ?? '', 2) : '';
  }
}
