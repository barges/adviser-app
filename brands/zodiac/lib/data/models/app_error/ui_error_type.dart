import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

enum UIErrorType {
  // blocked,
  // wrongUsernameAndOrPassword,
  // youCantSendThisMessageBecauseItsLessThanXSeconds,
  // youVeReachTheXMinuteTimeLimit,
  // theMaximumSizeOfTheAttachmentsIsXMb,
  checkYourInternetConnection;

  String getErrorMessage(BuildContext context, List<Object>? args) {
    switch (this) {
      // case UIErrorType.blocked:
      //   return SFortunica
      //       .of(context)
      //       .yourAccountHasBeenBlockedPleaseContactYourAdvisorManager;
      // case UIErrorType.wrongUsernameAndOrPassword:
      //   return SFortunica.of(context).wrongUsernameAndOrPassword;
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
    }
  }
}
