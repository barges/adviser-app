// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_item.g.dart';
part 'service_item.freezed.dart';

@freezed
class ServiceItem with _$ServiceItem {
  const ServiceItem._();

  @JsonSerializable(includeIfNull: false)
  const factory ServiceItem({
    int? id,
    String? name,
    @JsonKey(name: 'date_create') int? dateCreate,

    ///0 - New, 1 - Approved, 2 - Rejected, 3 - Temp
    int? status,

    ///0 - allowed, 1 - not allowed, 2 - Only services allowed
    @JsonKey(name: 'reject_status') int? rejectStatus,
    String? ext,
    @JsonKey(name: 'img') String? image,
    @JsonKey(name: 'reject_text') String? rejectText,
  }) = _ServiceItem;

  factory ServiceItem.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemFromJson(json);
}
