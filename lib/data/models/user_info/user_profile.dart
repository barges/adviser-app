import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/localized_properties.dart';
import 'package:shared_advisor_interface/data/models/user_info/rating.dart';

part 'user_profile.g.dart';

@JsonSerializable(includeIfNull: false)
class UserProfile {
  final Rating? rating;
  final List<String>? activeLanguages;
  final String? readerManager;
  final List<String>? profilePictures;
  final List<String>? coverPictures;
  final List<String>? galleryPictures;
  final List<String>? roles;
  final int? likeScore;
  final String? timezone;
  final int? loyaltyScore;
  final int? likesPercentage;
  final List<String>? rituals;
  final bool? isTestAccount;
  final LocalizedProperties? localizedProperties;
  final String? profileName;

  const UserProfile({
    this.rating,
    this.activeLanguages,
    this.readerManager,
    this.profilePictures,
    this.coverPictures,
    this.galleryPictures,
    this.roles,
    this.likeScore,
    this.timezone,
    this.loyaltyScore,
    this.likesPercentage,
    this.rituals,
    this.isTestAccount,
    this.localizedProperties,
    this.profileName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
