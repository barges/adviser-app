// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/reviews_list.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';

part 'detailed_user_info.g.dart';
part 'detailed_user_info.freezed.dart';

@freezed
class DetailedUserInfo with _$DetailedUserInfo {
  const DetailedUserInfo._();

  @JsonSerializable(
      includeIfNull: false, createToJson: true, explicitToJson: true)
  const factory DetailedUserInfo({
    UserDetails? details,
    ReviewsList? reviews,
    List<CategoryInfo>? category,
    List<String>? locales,
  }) = _DetailedUserInfo;

  factory DetailedUserInfo.fromJson(Map<String, dynamic> json) =>
      _$DetailedUserInfoFromJson(json);
}
