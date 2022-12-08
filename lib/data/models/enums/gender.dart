import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum Gender {

  male,
  female,
  @JsonValue("non_binary")
  nonBinary,
  @JsonValue("non_gender")
  nonGender;

  String get name {
    switch (this) {
      case Gender.male:
        return S.current.male;
        case Gender.female:
        return S.current.female;
        case Gender.nonBinary:
        return S.current.nonBinary;
      case Gender.nonGender:
        return S.current.preferNotToAnswer;
    }
  }
}
