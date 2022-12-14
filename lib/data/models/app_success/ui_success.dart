import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum UISuccessType {
  theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m,
  thisQuestionWillBeReturnedToTheGeneralListAfterCounter,
  youCanNotHelpUsersSinceYouHaveAnActive,
  weVeSentYouALinkToEmailToChangeYourPassword;

  String getSuccessMessage(BuildContext context, String? argument) {
    switch (this) {
      case UISuccessType
          .theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m:
        return S
            .of(context)
            .theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m;
      case UISuccessType.thisQuestionWillBeReturnedToTheGeneralListAfterCounter:
        return S
            .of(context)
            .thisQuestionWillBeReturnedToTheGeneralListAfterCounter(
                argument ?? '');
      case UISuccessType.youCanNotHelpUsersSinceYouHaveAnActive:
        return S.of(context).youCanNotHelpUsersSinceYouHaveAnActive;
      case UISuccessType.weVeSentYouALinkToEmailToChangeYourPassword:
        return S
            .of(context)
            .weVeSentYouALinkToEmailToChangeYourPassword(argument ?? '');
    }
  }
}

class UISuccess extends AppSuccess {
  UISuccess(UISuccessType uiSuccessType) : super(uiSuccessType, null);
  UISuccess.withArguments(UISuccessType uiSuccessType, String? argument)
      : super(uiSuccessType, argument);

  @override
  String getMessage(BuildContext context) {
    return uiSuccessType?.getSuccessMessage(context, argument) ?? '';
  }
}
