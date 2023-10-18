import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import 'ui_error_type.dart';

abstract class AppError {
  final String? message;
  const AppError({this.message});
  String getMessage(BuildContext context);
}

class EmptyError extends AppError {
  const EmptyError() : super();

  @override
  String getMessage(BuildContext context) {
    return '';
  }
}

class NetworkError extends AppError {
  const NetworkError({message}) : super(message: message);

  @override
  String getMessage(BuildContext context) {
    return message ?? SFortunica.of(context).unknownError;
  }
}

class UIError extends AppError {
  final UIErrorType uiErrorType;
  final List<Object>? args;

  UIError({required this.uiErrorType, this.args}) : super();

  @override
  String getMessage(BuildContext context) {
    return uiErrorType.getErrorMessage(context, args);
  }
}
