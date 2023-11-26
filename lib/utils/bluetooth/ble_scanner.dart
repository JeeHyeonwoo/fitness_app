import 'dart:async';

import 'package:fitnessapp/utils/bluetooth/reactive_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner({
    required FlutterReactiveBle ble,
    required Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final StreamController<BleScannerState> _stateStreamController = StreamController();
  StreamSubscription? _subscription;
  final _devices = <DiscoveredDevice>[];
  final serviceUuid = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  void startScan() {
    _logMessage('Start ble discovery');
    _devices.clear();
    _subscription?.cancel();
    _subscription = _ble.scanForDevices(withServices: []).listen((device) {
          final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
          if (knownDeviceIndex >= 0) {
            _devices[knownDeviceIndex] = device;
          } else {
            _devices.add(device);
            print("device info : ${device}");
          }
          _pushState();
        }, onError: (Object e) => _logMessage('Device scan fails with error: $e'));
    _pushState();

  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Stop ble discovery');

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  List<DiscoveredDevice> getDevices() {
    return _devices;
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}