import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkMonitor extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _networkStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get networkStatus => _networkStatusController.stream;

  NetworkMonitor() {
    _monitorNetworkStatus();
  }

  void _monitorNetworkStatus() {
    // Emit current connectivity state first
    _checkCurrentConnectivity();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      for (var action in result) {
        if(_mapResultToStatus(action)){
          _networkStatusController.add(true);
          break;
        }else{
          _networkStatusController.add(false);
        }
      }
    });
  }

  Future<void> _checkCurrentConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    for (var action in result) {
      if(_mapResultToStatus(action)){
        _networkStatusController.add(true);
        break;
      }else{
        _networkStatusController.add(false);
      }
    }
  }

  bool _mapResultToStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.none:
      default:
        return false;
    }
  }

  void dispose() {
    _networkStatusController.close();
  }
}
