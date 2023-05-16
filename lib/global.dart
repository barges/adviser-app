import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_advisor_interface/app_constants.dart';

final globalGetIt = GetIt.instance;

final Logger simpleLogger = Logger(printer: SimplePrinter());

final logger = Logger(
  filter: _MyLoggerFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: false,
  ),
);

final navigatorKey = GlobalKey<NavigatorState>();

class _MyLoggerFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return AppConstants.needPrintLogs;
  }
}
