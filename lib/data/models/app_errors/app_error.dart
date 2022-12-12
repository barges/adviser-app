import 'package:flutter/material.dart';

abstract class AppError {
  final String? message;
  const AppError(this.message);
  String getMessage(BuildContext context);
}
