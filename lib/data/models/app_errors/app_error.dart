import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_errors/ui_error_type.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

abstract class AppError {
  final String? message;
  const AppError(this.message);
  String getMessage(BuildContext context);
}

class EmptyError extends AppError {
  const EmptyError() : super(null);

  @override
  String getMessage(BuildContext context) {
    return '';
  }
}

class NetworkError extends AppError {
  const NetworkError(message) : super(message);

  @override
  String getMessage(BuildContext context) {
    return message ?? S.of(context).unknownError;
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
