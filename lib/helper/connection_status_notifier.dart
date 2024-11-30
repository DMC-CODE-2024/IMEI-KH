import 'dart:async';
import 'package:flutter/material.dart';
import 'network_connectivity.dart';

//Validating internet connectivity status and notifying while connecting or disconnecting
class ConnectionStatusNotifier extends ValueNotifier<Map<dynamic, dynamic>> {
  late StreamSubscription<dynamic> _connectivitySubscription;
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;

  ConnectionStatusNotifier() : super({}) {
    // Everytime there a new connection status is emitted
    // we will update the [value]. This will make the widget
    // to rebuild
    _networkConnectivity.initialise();
    _connectivitySubscription =
        _networkConnectivity.myStream.listen((event) => value = event);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
