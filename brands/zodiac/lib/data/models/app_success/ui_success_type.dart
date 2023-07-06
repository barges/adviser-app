import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

enum UISuccessMessagesType {
  weVeSentPasswordResetInstructionsToEmail,
  dailyCouponsSetUpSuccessful;

  String? getSuccessTitle(BuildContext context) {
    switch (this) {
      case UISuccessMessagesType.dailyCouponsSetUpSuccessful:
        return SZodiac.of(context).setUpSuccessfulZodiac;
      default:
        return null;
    }
  }

  String getSuccessMessage(BuildContext context, String? argument) {
    switch (this) {
      case UISuccessMessagesType.weVeSentPasswordResetInstructionsToEmail:
        return SZodiac.of(context)
            .weVeSentPasswordResetInstructionsToEmailZodiac(argument ?? '');
      case UISuccessMessagesType.dailyCouponsSetUpSuccessful:
        return SZodiac.of(context)
            .allSelectedCouponsAreReadyToBeDisplayedTomorrowZodiac;
    }
  }
}
