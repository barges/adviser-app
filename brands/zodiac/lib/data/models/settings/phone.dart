// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone.g.dart';
part 'phone.freezed.dart';

@freezed
class Phone with _$Phone {
  const Phone._();

  @JsonSerializable(
    includeIfNull: false,
    fieldRename: FieldRename.snake,
  )
  const factory Phone({
    int? code,
    int? number,
    bool? isVerified,
  }) = _Phone;

  factory Phone.fromJson(Map<String, dynamic> json) => _$PhoneFromJson(json);
}
