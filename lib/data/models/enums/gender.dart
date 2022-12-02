import 'package:shared_advisor_interface/generated/l10n.dart';

enum Gender {
  male,
  female;

  String get name {
    switch (this) {
      case Gender.female:
        return S.current.female;
      case Gender.male:
        return S.current.male;
    }
  }
}
