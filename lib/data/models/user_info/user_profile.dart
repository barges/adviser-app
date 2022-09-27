import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/localized_properties.dart';
import 'package:shared_advisor_interface/data/models/user_info/rating.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {

  @JsonSerializable(includeIfNull: false)
  const factory UserProfile({
    Rating? rating,
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
    List<String>? rituals,
    bool? isTestAccount,
    LocalizedProperties? localizedProperties,
    String? profileName,
}) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
