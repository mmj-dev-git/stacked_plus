import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

typedef ConnectivityChecker = Future<Object?> Function();

class ConnectivityService {
  ConnectivityService({
    ConnectivityChecker? checkConnectivity,
    Stream<Object?>? connectivityStream,
  }) : _checkConnectivity =
           checkConnectivity ?? Connectivity().checkConnectivity,
       _connectivityStream =
           connectivityStream ?? Connectivity().onConnectivityChanged;

  final ConnectivityChecker _checkConnectivity;
  final Stream<Object?> _connectivityStream;
  final _connectionStatusController = StreamController<bool>.broadcast();

  StreamSubscription<Object?>? _subscription;
  var _isConnected = true;
  var _isInitialised = false;

  bool get isConnected => _isConnected;

  Stream<bool> get onConnectionStatusChanged =>
      _connectionStatusController.stream.distinct();

  Future<void> initialise() async {
    if (_isInitialised) {
      return;
    }

    _isInitialised = true;
    await checkConnectivity();
    _subscription = _connectivityStream.listen(_setConnectionStatus);
  }

  Future<bool> checkConnectivity() async {
    final result = await _checkConnectivity();
    _setConnectionStatus(result);
    return _isConnected;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _connectionStatusController.close();
  }

  void _setConnectionStatus(Object? result) {
    final isConnected = _hasConnection(result);

    if (_isConnected == isConnected) {
      return;
    }

    _isConnected = isConnected;
    _connectionStatusController.add(_isConnected);
  }

  bool _hasConnection(Object? result) {
    final results = result is Iterable<Object?> ? result : [result];

    return results.any(
      (type) => type != null && type.toString() != 'ConnectivityResult.none',
    );
  }
}
