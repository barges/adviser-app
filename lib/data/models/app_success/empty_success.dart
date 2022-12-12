import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';

class EmptySuccess extends AppSuccess {
  const EmptySuccess() : super(null, null);

  @override
  String getMessage(BuildContext context) {
    return '';
  }
}
