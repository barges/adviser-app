import 'package:shared_advisor_interface/generated/l10n.dart';

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
        return S.of(context).pleaseInsertCorrectEmail;
      case ValidationErrorType.pleaseEnterAtLeast6Characters:
        return S.of(context).pleaseEnterAtLeast6Characters;
      case ValidationErrorType.requiredField:
        return S.of(context).requiredField;
      case ValidationErrorType.pleaseEnterAtLeast3Characters:
        return S.of(context).pleaseEnterAtLeast3Characters;
      case ValidationErrorType.thePasswordsMustMatch:
        return S.of(context).thePasswordsMustMatch;
      case ValidationErrorType.statusTextMayNotExceed300Characters:
        return S.of(context).statusTextMayNotExceed300Characters;
      case ValidationErrorType.empty:
        return '';
    }
  }
}
