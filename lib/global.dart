import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final globalGetIt = GetIt.instance;

final Logger simpleLogger = Logger(printer: SimplePrinter());

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: false,
  ),
);

final navigatorKey = GlobalKey<NavigatorState>();