import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';

class EmptyError extends AppError {
  const EmptyError() : super(null);

  @override
  String getMessage(BuildContext context) {
    return '';
  }
}
