import 'package:flutter/material.dart';

enum UISuccessMessagesType {
  weVeSentPasswordResetInstructionsToEmail;

  String getSuccessMessage(BuildContext context, String? argument) {
    switch (this) {
      case UISuccessMessagesType.weVeSentPasswordResetInstructionsToEmail:
        return 'We\'ve sent password reset instructions to $argument.';
    }
  }
}
