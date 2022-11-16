import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ConnectivityService {
  ConnectivityService._internal() {
    initialise();
  }

  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() {
    return _instance;
  }

  static bool hasConnection = false;

  static final Connectivity _connectivity = Connectivity();
  static final InternetConnectionChecker _checker = InternetConnectionChecker();

  static late final StreamSubscription _connectivitySubscription;
  static late final StreamSubscription _checkerSubscription;

  static final BehaviorSubject<bool> _controller = BehaviorSubject<bool>();

  Stream<bool> get connectivityStream => _controller.stream;

  static void initialise() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_addStatusFromConnectivity);
    _checkerSubscription =
        _checker.onStatusChange.listen(_addStatusFromChecker);
  }

  static Future<bool> checkConnection({ConnectivityResult? result}) async {
    result ??= await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
        {
          return _checker.hasConnection;
        }

      case ConnectivityResult.none:
        return false;
    }
  }

  static Future<void> _addStatusFromConnectivity(
      ConnectivityResult result) async {
    final bool previousConnection = hasConnection;
    hasConnection = await checkConnection(result: result);
    if (hasConnection != previousConnection) {
      _controller.sink.add(hasConnection);
    }
  }

  static Future<void> _addStatusFromChecker(
      InternetConnectionStatus status) async {
    final bool previousConnection = hasConnection;
    hasConnection = status == InternetConnectionStatus.connected;
    if (hasConnection != previousConnection) {
      _controller.sink.add(hasConnection);
    }
  }

  void disposeStream() {
    _controller.close();
    _connectivitySubscription.cancel();
    _checkerSubscription.cancel();
  }
}
