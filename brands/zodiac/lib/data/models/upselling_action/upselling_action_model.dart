// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'upselling_action_model.g.dart';
part 'upselling_action_model.freezed.dart';

@freezed
class UpsellingActionModel with _$UpsellingActionModel {
  const UpsellingActionModel._();

  @JsonSerializable(includeIfNull: false)
  const factory UpsellingActionModel({
    String? type,
    String? name,
    int? counter,
  }) = _UpsellingActionModel;

  factory UpsellingActionModel.fromJson(Map<String, dynamic> json) =>
      _$UpsellingActionModelFromJson(json);
}
