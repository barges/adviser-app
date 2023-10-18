import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../generated/l10n.dart';

enum Gender {
  male,
  female,
  @JsonValue("non_binary")
  nonBinary,
  @JsonValue("non_gender")
  nonGender,
  unknown;

  String name(BuildContext context) {
    switch (this) {
      case Gender.male:
        return SFortunica.of(context).maleFortunica;
      case Gender.female:
        return SFortunica.of(context).femaleFortunica;
      case Gender.nonBinary:
        return SFortunica.of(context).nonBinaryFortunica;
      case Gender.nonGender:
        return SFortunica.of(context).preferNotToAnswerFortunica;
      case Gender.unknown:
        return 'Unknown';
    }
  }

  static Gender genderFromString(String? name) {
    switch (name) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'non_binary':
        return Gender.nonBinary;
      case 'non_gender':
        return Gender.nonGender;
      default:
        return Gender.unknown;
    }
  }
}
