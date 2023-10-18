import '../../../generated/l10n.dart';

enum ValidationErrorType {
  pleaseInsertCorrectEmail,
  pleaseEnterAtLeast6Characters,
  requiredField,
  pleaseEnterAtLeast3Characters,
  thePasswordsMustMatch,
  statusTextMayNotExceed300Characters,
  empty;

  String text(context) {
    switch (this) {
      case ValidationErrorType.pleaseInsertCorrectEmail:
        return SFortunica.of(context).pleaseInsertCorrectEmailFortunica;
      case ValidationErrorType.pleaseEnterAtLeast6Characters:
        return SFortunica.of(context).pleaseEnterAtLeast6CharactersFortunica;
      case ValidationErrorType.requiredField:
        return SFortunica.of(context).requiredFieldFortunica;
      case ValidationErrorType.pleaseEnterAtLeast3Characters:
        return SFortunica.of(context).pleaseEnterAtLeast3CharactersFortunica;
      case ValidationErrorType.thePasswordsMustMatch:
        return SFortunica.of(context).thePasswordsMustMatchFortunica;
      case ValidationErrorType.statusTextMayNotExceed300Characters:
        return SFortunica.of(context)
            .statusTextMayNotExceed300CharactersFortunica;
      case ValidationErrorType.empty:
        return '';
    }
  }
}
