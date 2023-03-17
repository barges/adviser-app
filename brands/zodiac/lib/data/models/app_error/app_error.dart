
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/data/models/app_error/ui_error_type.dart';

class UIError extends AppError {
  final UIErrorType uiErrorType;
  final List<Object>? args;

  UIError({required this.uiErrorType, this.args}) : super();

  @override
  String getMessage(BuildContext context) {
    return uiErrorType.getErrorMessage(context, args);
  }
}
