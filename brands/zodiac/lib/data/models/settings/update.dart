// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update.g.dart';
part 'update.freezed.dart';

@freezed
class Update with _$Update {
  const Update._();

  @JsonSerializable(includeIfNull: false)
  const factory Update({
    String? title,
    String? text,
    bool? require,
  }) = _Update;

  factory Update.fromJson(Map<String, dynamic> json) => _$UpdateFromJson(json);
}
