
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
        return 'Please, insert correct email';
      case ValidationErrorType.pleaseEnterAtLeast8Characters:
        return 'Please enter at least 8 characters';
      case ValidationErrorType.requiredField:
        return 'Required field';
      case ValidationErrorType.pleaseEnterAtLeast3Characters:
        return 'Please enter at least 3 characters';
      case ValidationErrorType.thePasswordsMustMatch:
        return 'The passwords must match';
      case ValidationErrorType.empty:
        return '';
    }
  }
}
