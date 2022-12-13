import 'package:shared_advisor_interface/generated/l10n.dart';

enum ValidationErrorType {
  pleaseInsertCorrectEmail,
  pleaseEnterAtLeast6Characters,
  fieldIsRequired,
  pleaseEnterAtLeast3Characters,
  thePasswordsMustMatch,
  empty;

  String text(context) {
    switch (this) {
      case ValidationErrorType.pleaseInsertCorrectEmail:
        return S.of(context).pleaseInsertCorrectEmail;
      case ValidationErrorType.pleaseEnterAtLeast6Characters:
        return S.of(context).pleaseEnterAtLeast6Characters;
      case ValidationErrorType.fieldIsRequired:
        return S.of(context).fieldIsRequired;
      case ValidationErrorType.pleaseEnterAtLeast3Characters:
        return S.of(context).pleaseEnterAtLeast3Characters;
      case ValidationErrorType.thePasswordsMustMatch:
        return S.of(context).thePasswordsMustMatch;
      case ValidationErrorType.empty:
        return '';
    }
  }
}
