enum RecaptchaCustomAction {
  phoneVerifyNumber,
  phoneVerifyCode,
  phoneResendCode;

  @override
  String toString() {
    switch (this) {
      case RecaptchaCustomAction.phoneVerifyNumber:
        return 'phone_verify_number';
      case RecaptchaCustomAction.phoneVerifyCode:
        return 'phone_verify_code';
      case RecaptchaCustomAction.phoneResendCode:
        return 'phone_resend_code';
    }
  }
}
