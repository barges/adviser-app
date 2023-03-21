// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_info.g.dart';
part 'sign_in_info.freezed.dart';

@freezed
class SignInInfo with _$SignInInfo {
  const SignInInfo._();

  @JsonSerializable(includeIfNull: false, createToJson: true)
  const factory SignInInfo({
    int? id,
    String? email,
    String? name,
  }) = _SignInInfo;

  factory SignInInfo.fromJson(Map<String, dynamic> json) =>
      _$SignInInfoFromJson(json);
}
