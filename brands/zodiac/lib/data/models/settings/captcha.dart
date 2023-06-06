// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/settings/score_based.dart';

part 'captcha.g.dart';
part 'captcha.freezed.dart';

@freezed
class Captcha with _$Captcha {
  const Captcha._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory Captcha({
    String? description,
    ScoreBased? scoreBased,
  }) = _Captcha;

  factory Captcha.fromJson(Map<String, dynamic> json) =>
      _$CaptchaFromJson(json);
}
