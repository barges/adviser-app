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

  static final BehaviorSubject<bool> _controller = BehaviorSubject<bool>();

  Stream<bool> get connectivityStream => _controller.stream;

  static void initialise() async {
    _connectivity.onConnectivityChanged.listen((result) {
      _addStatus(result);
    });
  }

  static Future<bool> checkConnection({ConnectivityResult? result}) async {
    result ??= await _connectivity.checkConnectivity();
    try {
      final lookUp = await InternetAddress.lookup('example.com');
      logger.d('lookUp:$lookUp');
      switch (result) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
        case ConnectivityResult.bluetooth:
        case ConnectivityResult.ethernet:
          {
            return InternetConnectionChecker().hasConnection;
          }

        case ConnectivityResult.none:
          return false;
      }
    } catch (e) {
      logger.d('error');

      return false;
    }
  }

  static Future<void> _addStatus(ConnectivityResult result) async {
    bool previousConnection = hasConnection;
    hasConnection = await checkConnection(result: result);
    if (previousConnection != hasConnection) {
      _controller.sink.add(hasConnection);
    } else if (previousConnection == false && hasConnection == false) {
      await Future.delayed(const Duration(seconds: 10));
      await _addStatus(result);
    }
  }

  void disposeStream() => _controller.close();
}
