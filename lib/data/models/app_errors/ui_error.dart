import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum UIErrorType {
  blocked,
  wrongUsernameOrPassword;

  String getErrorMessage(BuildContext context) {
    switch (this) {
      case UIErrorType.blocked:
        return S
            .of(context)
            .yourAccountHasBeenBlockedPleaseContactYourAdvisorManager;
      case UIErrorType.wrongUsernameOrPassword:
        return S.of(context).wrongUsernameOrPassword;
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
