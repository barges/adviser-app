import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_success/ui_success_type.dart';

abstract class AppSuccess {
  final UISuccessType? uiSuccessType;
  final String? argument;

  const AppSuccess(this.uiSuccessType, this.argument);

  String getMessage(BuildContext context);
}

class EmptySuccess extends AppSuccess {
  const EmptySuccess() : super(null, null);

  @override
  String getMessage(BuildContext context) {
    return '';
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
