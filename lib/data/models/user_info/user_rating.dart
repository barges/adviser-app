import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_rating.freezed.dart';
part 'user_rating.g.dart';

@freezed
class UserRating with _$UserRating{

  @JsonSerializable(includeIfNull: false)
  const factory UserRating({
    double? de,
    double? en,
    double? es,
    double? pt,
  }) = _UserRating;

  factory UserRating.fromJson(Map<String, dynamic> json) =>
      _$UserRatingFromJson(json);
}