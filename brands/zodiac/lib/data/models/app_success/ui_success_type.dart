import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

enum UISuccessMessagesType {
  weVeSentPasswordResetInstructionsToEmail;

  String getSuccessMessage(BuildContext context, String? argument) {
    switch (this) {
      case UISuccessMessagesType.weVeSentPasswordResetInstructionsToEmail:
        return SZodiac.of(context)
            .weVeSentPasswordResetInstructionsToEmailZodiac(argument ?? '');
    }
  }
}
