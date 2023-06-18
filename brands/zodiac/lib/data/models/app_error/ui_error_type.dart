import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

enum UIErrorType {
  youWhereBlocked,
  wrongUsernameAndOrPassword,
  // youCantSendThisMessageBecauseItsLessThanXSeconds,
  // youVeReachTheXMinuteTimeLimit,
  // theMaximumSizeOfTheAttachmentsIsXMb,
  checkYourInternetConnection,
  loginDetailsSeemToBeIncorrect,
  youveReachedLimitPhone,
  phoneIsAlreadyExist,
  phoneVerificationUnavailable;

  String getErrorMessage(BuildContext context, List<Object>? args) {
    switch (this) {
      case UIErrorType.youWhereBlocked:
        return SZodiac.of(context).youWereBlocked;
      case UIErrorType.wrongUsernameAndOrPassword:
        return SZodiac.of(context).wrongUsernameAndOrPasswordZodiac;
      // case UIErrorType.youCantSendThisMessageBecauseItsLessThanXSeconds:
      //   return SFortunica
      //       .of(context)
      //       .youCantSendThisMessageBecauseItsLessThanXSeconds(args?[0] ?? '');
      // case UIErrorType.youVeReachTheXMinuteTimeLimit:
      //   return SFortunica.of(context).youVeReachTheXMinuteTimeLimit(args?[0] ?? '');
      // case UIErrorType.theMaximumSizeOfTheAttachmentsIsXMb:
      //   return SFortunica
      //       .of(context)
      //       .theMaximumSizeOfTheAttachmentsIsXMb(args?[0] ?? '');
      case UIErrorType.checkYourInternetConnection:
        return SZodiac.of(context).checkYourInternetConnectionZodiac;
      case UIErrorType.loginDetailsSeemToBeIncorrect:
        return SZodiac.of(context)
            .oopsYourLoginDetailsSeemToBeIncorrectGiveItAnotherTryOrTapResetPasswordZodiac;
      case UIErrorType.youveReachedLimitPhone:
        return SZodiac.of(context)
            .youveReachedLimitPhoneVerificationAttemptsZodiac;
      case UIErrorType.phoneIsAlreadyExist:
        return SZodiac.of(context).phoneIsAlreadyExistZodiac;
      case UIErrorType.phoneVerificationUnavailable:
        return SZodiac.of(context).sorryPhoneVerificationUnavailable;
    }
  }
}
