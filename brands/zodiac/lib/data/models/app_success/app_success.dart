import 'package:flutter/material.dart';
import 'package:zodiac/data/models/app_success/ui_success_type.dart';

abstract class AppSuccess {
  final UISuccessMessagesType? uiSuccessType;
  final String? argument;

  const AppSuccess(this.uiSuccessType, this.argument);

  String? getTitle(BuildContext context);

  String getMessage(BuildContext context);
}

class EmptySuccess extends AppSuccess {
  const EmptySuccess() : super(null, null);

  @override
  String getMessage(BuildContext context) {
    return '';
  }

  @override
  String? getTitle(BuildContext context) {
    return null;
  }
}

class UISuccess extends AppSuccess {
  UISuccess(UISuccessMessagesType uiSuccessType) : super(uiSuccessType, null);
  UISuccess.withArguments(UISuccessMessagesType uiSuccessType, String? argument)
      : super(uiSuccessType, argument);

  @override
  String getMessage(BuildContext context) {
    return uiSuccessType?.getSuccessMessage(context, argument) ?? '';
  }

  @override
  String? getTitle(BuildContext context) {
    return uiSuccessType?.getSuccessTitle(context);
  }
}
