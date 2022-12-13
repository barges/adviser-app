import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_success/ui_success.dart';

abstract class AppSuccess {
  final UISuccessType? uiSuccessType;
  final String? argument;

  const AppSuccess(this.uiSuccessType, this.argument);

  String getMessage(BuildContext context);
}
