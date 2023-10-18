import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

enum UISuccessMessagesType {
  theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m,
  thisQuestionWillBeReturnedToTheGeneralListAfterCounter,
  youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElse,
  weVeSentPasswordResetInstructionsToEmail;

  String getSuccessMessage(BuildContext context, String? argument) {
    switch (this) {
      case UISuccessMessagesType
            .theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m:
        return SFortunica.of(context)
            .theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1mFortunica;
      case UISuccessMessagesType
            .thisQuestionWillBeReturnedToTheGeneralListAfterCounter:
        return SFortunica.of(context)
            .thisQuestionWillBeReturnedToTheGeneralListAfterCounterFortunica(
                argument ?? '');
      case UISuccessMessagesType
            .youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElse:
        return SFortunica.of(context)
            .youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElseFortunica;
      case UISuccessMessagesType.weVeSentPasswordResetInstructionsToEmail:
        return SFortunica.of(context)
            .weVeSentPasswordResetInstructionsToEmailFortunica(argument ?? '');
    }
  }
}
