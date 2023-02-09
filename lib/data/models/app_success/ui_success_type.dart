import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum UISuccessType {
  theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m,
  thisQuestionWillBeReturnedToTheGeneralListAfterCounter,
  youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElse,
  weVeSentPasswordResetInstructionsToEmail;

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
      case UISuccessType
          .youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElse:
        return S
            .of(context)
            .youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElse;
      case UISuccessType.weVeSentPasswordResetInstructionsToEmail:
        return S
            .of(context)
            .weVeSentPasswordResetInstructionsToEmail(argument ?? '');
    }
  }
}
