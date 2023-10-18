import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

enum UIErrorType {
  blocked,
  wrongUsernameAndOrPassword,
  youCantSendThisMessageBecauseItsLessThanXSeconds,
  youVeReachTheXMinuteTimeLimit,
  theMaximumSizeOfTheAttachmentsIsXMb,
  checkYourInternetConnection;

  String getErrorMessage(BuildContext context, List<Object>? args) {
    switch (this) {
      case UIErrorType.blocked:
        return SFortunica.of(context)
            .yourAccountHasBeenBlockedPleaseContactYourAdvisorManagerFortunica;
      case UIErrorType.wrongUsernameAndOrPassword:
        return SFortunica.of(context).wrongUsernameAndOrPasswordFortunica;
      case UIErrorType.youCantSendThisMessageBecauseItsLessThanXSeconds:
        return SFortunica.of(context)
            .youCantSendThisMessageBecauseItsLessThanXSecondsFortunica(
                args?[0] ?? '');
      case UIErrorType.youVeReachTheXMinuteTimeLimit:
        return SFortunica.of(context)
            .youVeReachTheXMinuteTimeLimitFortunica(args?[0] ?? '');
      case UIErrorType.theMaximumSizeOfTheAttachmentsIsXMb:
        return SFortunica.of(context)
            .theMaximumSizeOfTheAttachmentsIsXMbFortunica(args?[0] ?? '');
      case UIErrorType.checkYourInternetConnection:
        return SFortunica.of(context).checkYourInternetConnectionFortunica;
    }
  }
}
