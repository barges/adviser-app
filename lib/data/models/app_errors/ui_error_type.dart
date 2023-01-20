import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

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
        return S
            .of(context)
            .yourAccountHasBeenBlockedPleaseContactYourAdvisorManager;
      case UIErrorType.wrongUsernameAndOrPassword:
        return S.of(context).wrongUsernameAndOrPassword;
      case UIErrorType.youCantSendThisMessageBecauseItsLessThanXSeconds:
        return S
            .of(context)
            .youCantSendThisMessageBecauseItsLessThanXSeconds(args?[0] ?? '');
      case UIErrorType.youVeReachTheXMinuteTimeLimit:
        return S.of(context).youVeReachTheXMinuteTimeLimit(args?[0] ?? '');
      case UIErrorType.theMaximumSizeOfTheAttachmentsIsXMb:
        return S
            .of(context)
            .theMaximumSizeOfTheAttachmentsIsXMb(args?[0] ?? '');
      case UIErrorType.checkYourInternetConnection:
        return S.of(context).checkYourInternetConnection;
    }
  }
}
