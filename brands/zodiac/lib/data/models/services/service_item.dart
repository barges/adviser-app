// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/service_status.dart';
import 'package:zodiac/data/models/enums/service_type.dart';

part 'service_item.g.dart';
part 'service_item.freezed.dart';

@freezed
class ServiceItem with _$ServiceItem {
  const ServiceItem._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory ServiceItem({
    @JsonKey(name: 'service_id') int? id,
    @JsonKey(fromJson: ServiceStaus.fromInt) ServiceStaus? status,
    double? price,
    String? durationView,
    @JsonKey(fromJson: ServiceType.fromInt) ServiceType? type,
    String? image,
    String? name,
    String? description,
    @Default(false) bool isActive,
  }) = _ServiceItem;

  factory ServiceItem.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemFromJson(json);
}
