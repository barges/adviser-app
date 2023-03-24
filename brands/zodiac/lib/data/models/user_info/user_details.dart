// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/video_info.dart';

part 'user_details.g.dart';

part 'user_details.freezed.dart';

@freezed
class UserDetails with _$UserDetails {
  const UserDetails._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory UserDetails({
    int? id,
    String? name,
    String? email,
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
    @Default(ZodiacUserStatus.offline)
        ZodiacUserStatus status,
    dynamic forceStatus,
    int? chatsQuantity,
    int? approvalStatus,
    @JsonKey(name: 'have_chat') int? chatEnabled,
    @JsonKey(name: 'have_call') int? callEnabled,
    dynamic phone,
    String? locale,
    String? shortDescription,
    String? aboutDescription,
    String? experienceDescription,
    double? callFee,
    double? chatFee,
    String? specializing,
    double? averageRatingReal,
    String? enableTranslation,
    String? elId,
    String? isFavorite,
    String? avatar,
    int? havePrivate,
    double? callFeeDiscount,
    double? chatFeeDiscount,
    double? discountPercent,
    VideoInfo? video,
    int? randomCallEnabled,
    double? randomCallFee,
    double? averageRating,
    int? callCount,
    int? chatCount,
    int? inchatservice,
    dynamic notifications,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);
}

ZodiacUserStatus _statusFromJson(num? value) {
  int? status = value?.toInt();
  return ZodiacUserStatus.statusFromInt(status);
}

int _statusToJson(ZodiacUserStatus value) {
  return value.intFromStatus;
}
