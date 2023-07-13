// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'canned_message.g.dart';
part 'canned_message.freezed.dart';

@freezed
class CannedMessage with _$CannedMessage {
  const CannedMessage._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory CannedMessage({
    int? id,
    int? categoryId,
    @JsonKey(fromJson: _toString) String? text,
    int? dateCreate,
    String? categoryName,
  }) = _CannedMessage;

  factory CannedMessage.fromJson(Map<String, dynamic> json) =>
      _$CannedMessageFromJson(json);
}

String? _toString(value) => value is String ? value : value?.toString();
