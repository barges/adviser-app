import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

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
        return S.of(context).male;
      case Gender.female:
        return S.of(context).female;
      case Gender.nonBinary:
        return S.of(context).nonBinary;
      case Gender.nonGender:
        return S.of(context).preferNotToAnswer;
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
