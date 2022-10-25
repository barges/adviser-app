import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/localized_properties.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_rating.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  @JsonSerializable(includeIfNull: false)
  const factory UserProfile({
    UserRating? rating,
    List<String>? activeLanguages,
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
