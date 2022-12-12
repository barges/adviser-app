import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum UIErrorType {
  blocked,
  wrongUsernameOrPassword,
  youCantSendThisMessageBecauseItsLessThan15Seconds,
  recordingStoppedBecauseAudioFileIsReachedTheLimitOf3min,
  theMaximumImageSizeIs20Mb,
  checkYourInternetConnection;

  String getErrorMessage(BuildContext context) {
    switch (this) {
      case UIErrorType.blocked:
        return S
            .of(context)
            .yourAccountHasBeenBlockedPleaseContactYourAdvisorManager;
      case UIErrorType.wrongUsernameOrPassword:
        return S.of(context).wrongUsernameOrPassword;
      case UIErrorType.youCantSendThisMessageBecauseItsLessThan15Seconds:
        return S.of(context).youCantSendThisMessageBecauseItsLessThan15Seconds;
      case UIErrorType.recordingStoppedBecauseAudioFileIsReachedTheLimitOf3min:
        return S
            .of(context)
            .recordingStoppedBecauseAudioFileIsReachedTheLimitOf3min;
      case UIErrorType.theMaximumImageSizeIs20Mb:
        return S.of(context).theMaximumImageSizeIs20Mb;
      case UIErrorType.checkYourInternetConnection:
        return S.of(context).checkYourInternetConnection;
    }
  }
}

class UIError extends AppError {
  final UIErrorType uiErrorType;

  UIError({required this.uiErrorType}) : super(null);

  @override
  String getMessage(BuildContext context) {
    return uiErrorType.getErrorMessage(context);
  }
}
