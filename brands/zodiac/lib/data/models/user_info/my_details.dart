// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/contact_info.dart';
import 'package:zodiac/data/models/user_info/fee_info.dart';
import 'package:zodiac/data/models/user_info/personal_info.dart';
import 'package:zodiac/data/models/user_info/sign_in_info.dart';

part 'my_details.g.dart';
part 'my_details.freezed.dart';

@freezed
class MyDetails with _$MyDetails {
  const MyDetails._();

  @JsonSerializable(
      includeIfNull: false, explicitToJson: true)
  const factory MyDetails({
    @JsonKey(name: 'sign_in') SignInInfo? signInInfo,
    PersonalInfo? personal,
    ContactInfo? contact,
    FeeInfo? fee,
    List<CategoryInfo>? category,
  }) = _MyDetails;

  factory MyDetails.fromJson(Map<String, dynamic> json) =>
      _$MyDetailsFromJson(json);
}
