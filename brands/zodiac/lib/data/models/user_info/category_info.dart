// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_info.g.dart';
part 'category_info.freezed.dart';

@freezed
class CategoryInfo with _$CategoryInfo {
  const CategoryInfo._();

  @JsonSerializable(
      includeIfNull: false, explicitToJson: true)
  const factory CategoryInfo({
    int? id,
    int? pid,
    String? name,
    String? alias,
    String? icon,
    int? checked,
    String? image,
    List<CategoryInfo>? sublist,
  }) = _CategoryInfo;

  factory CategoryInfo.fromJson(Map<String, dynamic> json) =>
      _$CategoryInfoFromJson(json);
}
