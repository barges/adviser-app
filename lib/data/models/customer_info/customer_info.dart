// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../network/responses/customer_info_response/questions_subscription.dart';
import '../enums/gender.dart';
import '../enums/zodiac_sign.dart';

part 'customer_info.g.dart';
part 'customer_info.freezed.dart';

@freezed
class CustomerInfo with _$CustomerInfo {
  @JsonSerializable(includeIfNull: false)
  factory CustomerInfo({
    QuestionsSubscription? questionsSubscription,
    @JsonKey(name: '_id') String? lId,
    String? country,
    DateTime? birthdate,
    String? firstName,
    @JsonKey(unknownEnumValue: Gender.unknown) Gender? gender,
    String? lastName,
    ZodiacSign? zodiac,
    bool? isProfileCompleted,
    String? id,
    String? countryFullName,
    int? totalMessages,
    Map<String, String>? advisorMatch,
  }) = _CustomerInfo;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoFromJson(json);
}
