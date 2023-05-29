// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_box.g.dart';

part 'product_box.freezed.dart';

@freezed
class ProductBox with _$ProductBox {
  const ProductBox._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory ProductBox({
    int? id,
    String? icon,
    String? name,
    dynamic price, //Can be String or double
    dynamic prId, //Can  be String or double
    @JsonKey(
      name: 'status',
      fromJson: _boolFromInt,
      toJson: _boolToInt,
    )
    @Default(false)
    bool isPaid,
  }) = _ProductBox;

  factory ProductBox.fromJson(Map<String, dynamic> json) =>
      _$ProductBoxFromJson(json);
}

bool _boolFromInt(num? status) => status == 1;

int _boolToInt(bool status) => status ? 1 : 0;
