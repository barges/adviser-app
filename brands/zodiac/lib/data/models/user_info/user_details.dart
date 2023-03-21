// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/video_info.dart';

part 'user_details.g.dart';
part 'user_details.freezed.dart';

@freezed
class UserDetails with _$UserDetails {
  const UserDetails._();

  @JsonSerializable(
      includeIfNull: false, createToJson: true, explicitToJson: true)
  const factory UserDetails({
    int? id,
    String? name,
    String? email,
    int? status,
    @JsonKey(name: 'force_status') dynamic forceStatus,
    @JsonKey(name: 'chats_quantity') int? chatsQuantity,
    @JsonKey(name: 'approval_status') int? approvalStatus,
    @JsonKey(name: 'have_chat') int? chatEnabled,
    @JsonKey(name: 'have_call') int? callEnabled,
    dynamic phone,
    String? locale,
    @JsonKey(name: 'short_description') String? shortDescription,
    @JsonKey(name: 'about_description') String? aboutDescription,
    @JsonKey(name: 'experience_description') String? experienceDescription,
    @JsonKey(name: 'call_fee') double? callFee,
    @JsonKey(name: 'chat_fee') double? chatFee,
    String? specializing,
    @JsonKey(name: 'average_rating_real') double? averageRatingReal,
    @JsonKey(name: 'enable_translation') String? enableTranslation,
    @JsonKey(name: 'el_id') String? elId,
    @JsonKey(name: 'is_favorite') String? isFavorite,
    String? avatar,
    @JsonKey(name: 'have_private') int? havePrivate,
    @JsonKey(name: 'call_fee_discount') double? callFeeDiscount,
    @JsonKey(name: 'chat_fee_discount') double? chatFeeDiscount,
    @JsonKey(name: 'discount_percent') double? discountPercent,
    VideoInfo? video,
    @JsonKey(name: 'random_call_enabled') int? randomCallEnabled,
    @JsonKey(name: 'random_call_fee') double? randomCallFee,
    @JsonKey(name: 'average_rating') double? averageRating,
    @JsonKey(name: 'call_count') int? callCount,
    @JsonKey(name: 'chat_count') int? chatCount,
    int? inchatservice,
    dynamic notifications,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);
}
