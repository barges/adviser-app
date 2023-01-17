// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'limitation.freezed.dart';
part 'limitation.g.dart';

@freezed
class Limitation with _$Limitation {
  @JsonSerializable(includeIfNull: false)
  const factory Limitation({
    final int? min,
    final int? max,
  }) = _Limitation;

  factory Limitation.fromJson(Map<String, dynamic> json) =>
      _$LimitationFromJson(json);
}
