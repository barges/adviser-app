import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum UIErrorType {
  blocked,
  wrongUsernameAndOrPassword,
  youCantSendThisMessageBecauseItsLessThan15Seconds,
  youVeReachThe3MinuteTimeLimit,
  theMaximumSizeOfTheAttachmentsIs20Mb,
  checkYourInternetConnection;

  String getErrorMessage(BuildContext context) {
    switch (this) {
      case UIErrorType.blocked:
        return S
            .of(context)
            .yourAccountHasBeenBlockedPleaseContactYourAdvisorManager;
      case UIErrorType.wrongUsernameAndOrPassword:
        return S.of(context).wrongUsernameAndOrPassword;
      case UIErrorType.youCantSendThisMessageBecauseItsLessThan15Seconds:
        return S.of(context).youCantSendThisMessageBecauseItsLessThan15Seconds;
      case UIErrorType.youVeReachThe3MinuteTimeLimit:
        return S.of(context).youVeReachThe3MinuteTimeLimit;
      case UIErrorType.theMaximumSizeOfTheAttachmentsIs20Mb:
        return S.of(context).theMaximumSizeOfTheAttachmentsIs20Mb;
      case UIErrorType.checkYourInternetConnection:
        return S.of(context).checkYourInternetConnection;
    }
  }
}
