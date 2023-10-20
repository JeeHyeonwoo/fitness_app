import 'dart:async';

import 'package:fitnessapp/utils/bluetooth/reactive_state.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class  BleDeviceConnector extends ReactiveState<ConnectionStateUpdate> {
  BleDeviceConnector({
    required FlutterReactiveBle ble,
    required Function(String message) logMessage,
  }) : _ble = ble, _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();
  late StreamSubscription<ConnectionStateUpdate> _connection;

  Future<void> connect(String deviceId) async {
    _logMessage('Start connecting to $deviceId');
    _connection = _ble.connectToDevice(id: deviceId)
        .listen((update) {
          print("update 내용 : ${update}");
          _deviceConnectionController.add(update);
    });
  }

  Future<void> disconnect(String deviceId) async {
    try{
      await _connection.cancel();
    } on Exception catch(e, _ ){
      print("Error disconnecting from a device : $e");
    } finally {
      _deviceConnectionController.add(
          ConnectionStateUpdate(deviceId: deviceId, connectionState: DeviceConnectionState.disconnected, failure: null)
      );
    }
  }

  @override
  Stream<ConnectionStateUpdate> get state =>_deviceConnectionController.stream;
}