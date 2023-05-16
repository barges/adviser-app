// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_data.g.dart';

part 'product_data.freezed.dart';

@freezed
class ProductData with _$ProductData {
  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory ProductData({
    List<double>? priceList,
    double? defPrice,
  }) = _ProductData;

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);
}
