// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_info.g.dart';

part 'category_info.freezed.dart';

@freezed
class CategoryInfo with _$CategoryInfo {
  const CategoryInfo._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory CategoryInfo({
    int? id,
    @JsonKey(name: 'pid') int? parentId,
    String? name,
    String? alias,
    String? icon, //for categories
    int? checked,
    String? image,
    String? iconUrl, //for methods
    List<CategoryInfo>? sublist,
  }) = _CategoryInfo;

  factory CategoryInfo.fromJson(Map<String, dynamic> json) =>
      _$CategoryInfoFromJson(json);

  static List<CategoryInfo> normalizeList(List<CategoryInfo> list) {
    final List<CategoryInfo> categories = [];
    for (CategoryInfo categoryInfo in list) {
      List<CategoryInfo>? sublist = categoryInfo.sublist;
      if (sublist != null && sublist.isNotEmpty) {
        categories.add(categoryInfo.copyWith(sublist: null));
        categories.addAll(sublist);
      } else {
        categories.add(categoryInfo);
      }
    }
    return categories;
  }
}
