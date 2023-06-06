// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_country_code.g.dart';
part 'phone_country_code.freezed.dart';

@freezed
class PhoneCountryCode with _$PhoneCountryCode {
  const PhoneCountryCode._();

  @JsonSerializable(includeIfNull: false)
  const factory PhoneCountryCode({
    String? name,
    String? code,
  }) = _PhoneCountryCode;

  factory PhoneCountryCode.fromJson(Map<String, dynamic> json) =>
      _$PhoneCountryCodeFromJson(json);

  int? toCodeInt() {
    return code != null ? int.tryParse(code!) : null;
  }
}
