import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class NetworkError extends AppError {
  const NetworkError(message) : super(message);

  @override
  String getMessage(BuildContext context) {
    return message ?? S.of(context).unknownError;
  }
}
