import 'package:zodiac/generated/l10n.dart';

enum ValidationErrorType {
  pleaseInsertCorrectEmail,
  pleaseEnterAtLeast8Characters,
  requiredField,
  theNicknameIsInvalidMustBe3to250Symbols,
  characterLimitExceeded,
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
      case ValidationErrorType.theNicknameIsInvalidMustBe3to250Symbols:
        return SZodiac.of(context).theNicknameIsInvalidMustBe3to250SymbolsZodiac;
      case ValidationErrorType.characterLimitExceeded:
        return SZodiac.of(context).characterLimitExceededZodiac;
      case ValidationErrorType.thePasswordsMustMatch:
        return SZodiac.of(context).thePasswordsMustMatchZodiac;
      case ValidationErrorType.empty:
        return '';
    }
  }
}
