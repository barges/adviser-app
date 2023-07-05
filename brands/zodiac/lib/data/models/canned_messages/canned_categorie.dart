// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'canned_categorie.g.dart';
part 'canned_categorie.freezed.dart';

@freezed
class CannedCategorie with _$CannedCategorie {
  const CannedCategorie._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory CannedCategorie({
    int? id,
    String? name,
  }) = _CannedCategorie;

  factory CannedCategorie.fromJson(Map<String, dynamic> json) =>
      _$CannedCategorieFromJson(json);
}
