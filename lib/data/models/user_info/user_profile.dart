// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/markets_type.dart';
import '../enums/sessions_types.dart';
import 'localized_properties/localized_properties.dart';

part 'user_profile.freezed.dart';

part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  @JsonSerializable(includeIfNull: false)
  const factory UserProfile({
    @JsonKey(fromJson: _ratingFromJson) Map<MarketsType, double?>? rating,
    @JsonKey(fromJson: _activeLanguagesFromJson)
    List<MarketsType>? activeLanguages,
    List<String>? profilePictures,
    List<String>? coverPictures,
    List<String>? galleryPictures,
    @JsonKey(fromJson: _ritualsFromJson) List<SessionsTypes>? rituals,
    bool? isTestAccount,
    LocalizedProperties? localizedProperties,
    String? profileName,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

List<MarketsType>? _activeLanguagesFromJson(json) {
  final List<MarketsType> markets = [];

  (json as List<dynamic>?)?.forEach((element) {
    final String market = element as String;
    if (MarketsType.actualMarkets.contains(market)) {
      markets.add(MarketsType.typeFromString(market));
    }
  });
  return markets;
}

Map<MarketsType, double?>? _ratingFromJson(json) {
  final Map<MarketsType, double?> ratingMap = {};

  (json as Map<String, dynamic>?)?.forEach((key, value) {
    if (MarketsType.actualMarkets.contains(key)) {
      if (value is double) {
        ratingMap[MarketsType.typeFromString(key)] = value;
      }
    }
  });
  return ratingMap;
}

List<SessionsTypes>? _ritualsFromJson(json) {
  final List<SessionsTypes> rituals = [];

  (json as List<dynamic>?)?.forEach((element) {
    final String ritual = element as String;
    if (SessionsTypes.actualSessionsTypes.contains(ritual)) {
      rituals.add(SessionsTypes.typeFromString(ritual));
    }
  });
  return rituals;
}
