import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:flutter/material.dart';

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
    return message ?? S.of(context).unknownError;
  }
}