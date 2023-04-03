import 'package:zodiac/generated/l10n.dart';

enum ValidationErrorType {
  pleaseInsertCorrectEmail,
  pleaseEnterAtLeast8Characters,
  requiredField,
  pleaseEnterAtLeast3Characters,
  thePasswordsMustMatch,
  empty;

  String text(context) {
    switch (this) {
      case ValidationErrorType.pleaseInsertCorrectEmail:
        return SZodiac.of(context).pleaseInsertCorrectEmailZodiac;
      case ValidationErrorType.pleaseEnterAtLeast8Characters:
        return SZodiac.of(context).pleaseEnterAtLeast8CharactersZodiac;
      case ValidationErrorType.requiredField:
        return SZodiac.of(context).requiredFieldZodiac;
      case ValidationErrorType.pleaseEnterAtLeast3Characters:
        return SZodiac.of(context).pleaseEnterAtLeast3CharactersZodiac;
      case ValidationErrorType.thePasswordsMustMatch:
        return SZodiac.of(context).thePasswordsMustMatchZodiac;
      case ValidationErrorType.empty:
        return '';
    }
  }
}
