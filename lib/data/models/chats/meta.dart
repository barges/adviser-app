// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

@freezed
class Meta with _$Meta {
  @JsonSerializable(includeIfNull: false)
  const factory Meta({
    @JsonKey(fromJson: _toInt) int? duration,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

int? _toInt(num? value) => value?.toInt();
