import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/localized_properties.dart';

part 'user_profile.freezed.dart';

part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  @JsonSerializable(includeIfNull: false)
  const factory UserProfile({
    Map<MarketsType, double>? rating,
    List<MarketsType>? activeLanguages,
    String? readerManager,
    List<String>? profilePictures,
    List<String>? coverPictures,
    List<String>? galleryPictures,
    List<String>? roles,
    int? likeScore,
    String? timezone,
    int? loyaltyScore,
    int? likesPercentage,
    List<SessionsTypes>? rituals,
    bool? isTestAccount,
    LocalizedProperties? localizedProperties,
    String? profileName,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
