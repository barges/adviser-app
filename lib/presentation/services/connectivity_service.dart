import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityService {
  ConnectivityService._internal() {
    initialise();
  }

  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() {
    return _instance;
  }

  static bool hasConnection = false;

  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _checker = InternetConnectionChecker();

  late final StreamSubscription _connectivitySubscription;
  late final StreamSubscription _checkerSubscription;

  final BehaviorSubject<bool> _controller = BehaviorSubject<bool>();

  Stream<bool> get connectivityStream => _controller.stream;

  void initialise() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_addStatusFromConnectivity);
    _checkerSubscription =
        _checker.onStatusChange.listen(_addStatusFromChecker);
  }

  Future<bool> checkConnection({ConnectivityResult? result}) async {
    result ??= await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        {
          final bool previousConnection = hasConnection;
          hasConnection = await _checker.hasConnection;
          if (hasConnection != previousConnection) {
            _controller.sink.add(hasConnection);
          }
          return hasConnection;
        }

      case ConnectivityResult.none:
        return false;
      case ConnectivityResult.other:
        return true;
    }
  }

  Future<void> _addStatusFromConnectivity(ConnectivityResult result) async {
    final bool previousConnection = hasConnection;
    hasConnection = await checkConnection(result: result);
    if (hasConnection != previousConnection) {
      _controller.sink.add(hasConnection);
    }
  }

  Future<void> _addStatusFromChecker(InternetConnectionStatus status) async {
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
