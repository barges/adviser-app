// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/services/service_item.dart';

part 'service_list_result.g.dart';
part 'service_list_result.freezed.dart';

@freezed
class ServiceListResult with _$ServiceListResult {
  const ServiceListResult._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory ServiceListResult({
    @JsonKey(name: 'active_count') int? count,
    List<ServiceItem>? list,
  }) = _ServiceListResult;

  factory ServiceListResult.fromJson(Map<String, dynamic> json) =>
      _$ServiceListResultFromJson(json);
}
