// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/approval_service_language_model.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';

part 'service_info_item.g.dart';
part 'service_info_item.freezed.dart';

@freezed
class ServiceInfoItem with _$ServiceInfoItem {
  const ServiceInfoItem._();

  @JsonSerializable(includeIfNull: false)
  const factory ServiceInfoItem({
    @JsonKey(name: 'service_id') int? id,
    int? status,
    String? image,
    @JsonKey(name: 'default_locale') String? mainLocale,
    @JsonKey(fromJson: ServiceType.fromInt) ServiceType? type,
    List<ServiceLanguageModel>? translations,
    double? price,
    int? duration,
    int? discount,
    List<ApprovalServiceLanguageModel>? approval,
  }) = _ServiceInfoItem;

  factory ServiceInfoItem.fromJson(Map<String, dynamic> json) =>
      _$ServiceInfoItemFromJson(json);
}
