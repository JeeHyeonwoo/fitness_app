import 'dart:async';
import 'dart:ffi';

import 'package:fitnessapp/utils/bluetooth/ble_device_connector.dart';
import 'package:fitnessapp/utils/bluetooth/ble_scanner.dart';
import 'package:fitnessapp/utils/db/db_init.dart';
import 'package:fitnessapp/utils/db/workout_record/workout_record.dart';
import 'package:fitnessapp/utils/db/workout_record/workout_record_recent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/app_colors.dart';
import '../../utils/widget/button/round_button.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);
  static String routeName = "/WorkoutRunningScreen";

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with TickerProviderStateMixin {
  late AnimationController timerController;
  final TextEditingController textEditingController = TextEditingController();
  Timer? _timer;

  // Bluetooth
  late FlutterReactiveBle _ble;
  late BleScanner _scanner;

  late BleDeviceConnector _leftConnection;
  late BleDeviceConnector _rightConnection;
  String? leftDeviceId;
  String? rightDeviceId;

  final Uuid uuid = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");

  final StreamController<bool> _bleConnectionController = StreamController();
  bool isPlaying = false;
  bool leftBleConnection = false;
  bool rightBleConnection = false;
  WorkoutRecordRecent _workoutRecordRecent = WorkoutRecordRecent();

  int _initTime = 900;
  int _useTime = 0;
  int _counting = 0;

  String get timeText {
    Duration count = timerController.duration! * timerController.value;
    return timerController.isDismissed
        ? '${timerController.duration!.inHours}:${(timerController.duration!.inMinutes % 60).toString().padLeft(2,'0')}:${(timerController.duration!.inSeconds % 60).toString().padLeft(2,'0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2,'0')}:${(count.inSeconds % 60).toString().padLeft(2,'0')}';
  }

  double progress = 1.0;

  Stream<bool> get bleState => _bleConnectionController.stream;

  void _pushBleState(bool state) {
    print("ble state: ${state}");
    _bleConnectionController.add(state);
  }

  void notify() {
    if (timeText == '0:00:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    // DB Setting
    _pushBleState(false);
    //ble constructor
    _ble = FlutterReactiveBle();
    _scanner = BleScanner(ble: _ble, logMessage: (message){});
    _leftConnection = BleDeviceConnector(ble: _ble, logMessage: (message) {});
    _leftConnection.state.listen((state) {
      if (state.connectionState == DeviceConnectionState.connected) {
        setState(() {
          leftDeviceId = state.deviceId;
          leftBleConnection = true;
        });

      } else {
        setState(() {
          leftBleConnection = false;
        });
        print("왼쪽 디바이스 연결 끊김: ${state.connectionState}");
      }
    });

    _rightConnection = BleDeviceConnector(ble: _ble, logMessage: (message) {});
    _rightConnection.state.listen((state) {
      if (state.connectionState == DeviceConnectionState.connected) {
        setState(() {
          rightDeviceId = state.deviceId;
          rightBleConnection = true;
        });
      } else {
        setState(() {
          rightBleConnection = false;
        });
        print("오른쪽 디바이스 연결 끊김: ${state.connectionState}");
      }
    });

    timerController = AnimationController(
        vsync: this,
        duration: Duration(seconds: _initTime),
    );

    timerController.addListener(() {
      notify();
      if (timerController.isAnimating) {
        setState(() {
          progress = timerController.value;
        });
      }else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });

    textEditingController.addListener(() {
      notify();
      if (!textEditingController.hasListeners) {
        setState((){
          progress = 1.0;
          isPlaying = false;
          textEditingController.text = "10";
        });
      }
    });
    textEditingController.text = "10";
  }
  void _timerStart() {
    print("타이머 시작!");
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _useTime++;
      });
    });

    test();
    // count setting
  }

  void _timerStop() {
    _timer?.cancel();
  }

  Future<void> _timerReset() async{
    /*_counting += 30;
    _useTime += 300;*/
    if (_counting > 0 && _useTime > 0 ) {
      _useTime++; // 약간의 시간 오차 해결
      WorkoutRecord workoutRecord = WorkoutRecord(dateTime: DateTime.now().toString(), useTime: _useTime, count: _counting);
      Database database = await DatabaseInit().database;
      await database.insert("WorkoutRecord", workoutRecord.toMap());
      _workoutRecordRecent.notify();
    }
    _timer?.cancel();
    _useTime = 0;
    _counting = 0;
  }

  void getCount() {
    // 블루투스 연결 여부 확인
    bleState.listen((event) {
      if(event) {
        print("Get Data");  // 연속적으로 데이터를 받아와야함.
      }
    });
  }

  void stopGetCount() {
  }

  Future<void> test() async {
    final characteristic = QualifiedCharacteristic(serviceId: uuid, characteristicId: uuid, deviceId: leftDeviceId!);
    final response = await _ble.readCharacteristic(characteristic);
    print(response);
  }


  @override
  void dispose() {
    _timerReset();
    _scanner.dispose();
    timerController.dispose();
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text("운동",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                var requestStatus = await Permission.bluetoothScan.request();
                await Permission.bluetoothConnect.request();

                if(requestStatus.isGranted) {
                  // 연결이 안되어 있을시
                  if (!leftBleConnection) {
                    print("검색");
                    _scanner.startScan();
                    await Future.delayed(Duration(seconds: 5));
                    await _scanner.stopScan();
                    print("디바이스 검색 종료 : ${_scanner.getDevices()}");

                    for(DiscoveredDevice device in _scanner.getDevices()) {
                      if (device.name == "STEPPER_L Service") {
                        print("왼쪽 디바이스 연결 시도");
                        _leftConnection.connect(device.id);
                      }
                    }
                  } else {
                    if(leftDeviceId != null) {
                      _leftConnection.disconnect(leftDeviceId!);
                      setState(() {
                        leftDeviceId = null;
                      });
                    }
                  }
                }
              },
              icon: leftBleConnection ? Icon(Icons.bluetooth_connected, color: Colors.blue, size: 30,) : Icon(Icons.bluetooth_disabled, color: Colors.red, size: 30,)),

          IconButton(
              onPressed: () async {
                var requestStatus = await Permission.bluetoothScan.request();
                await Permission.bluetoothConnect.request();

                if(requestStatus.isGranted) {
                  // 연결이 안되어 있을시
                  if (!rightBleConnection) {
                    print("검색");
                    _scanner.startScan();
                    await Future.delayed(Duration(seconds: 2));
                    await _scanner.stopScan();
                    print("디바이스 검색 종료 : ${_scanner.getDevices()}");

                    for(DiscoveredDevice device in _scanner.getDevices()) {
                      if (device.name == "STEPPER_R Service") {
                        print("오른쪽 디바이스 연결 시도");
                        _rightConnection.connect(device.id);
                      }
                    }
                  } else {
                    if(rightDeviceId != null) {
                      _rightConnection.disconnect(rightDeviceId!);
                      setState(() {
                        leftDeviceId = null;
                      });
                    }
                  }
                }
              },
              icon: rightBleConnection ? Icon(Icons.bluetooth_connected, color: Colors.blue, size: 30,) : Icon(Icons.bluetooth_disabled, color: Colors.red, size: 30,))
        ],
      ),
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    value: progress,
                    strokeWidth: 6,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (timerController.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: timerController.duration!,
                            onTimerDurationChanged: (time) {
                              setState(() {
                                timerController.duration = time;
                                _initTime = time.inSeconds;
                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: timerController,
                    builder: (context, child) => Text(
                      timeText,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (timerController.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return NumberPicker(
                                minValue: 10,
                                maxValue: 10000,
                                step: 10,
                                value: int.parse(textEditingController.text),
                                onChanged: (int value) {
                                  setState(() {
                                    textEditingController.text = value.toString();
                                  });
                                },
                              );
                            },
                          )
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: textEditingController,
                    builder: (context, child) => Text(
                      textEditingController.text,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (timerController.isAnimating) {
                      timerController.stop();
                      _timerStop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      _timerStart();
                      timerController.reverse(
                          from: timerController.value == 0 ? 1.0 : timerController.value);
                      setState(() {
                        isPlaying = true;
                      });
                      // 걸음수 디비에 저장
                      // todo: 디바이스 연결될 경우 수정해야함

                      // 시간 디비에 저장

                    }
                  },
                  child: RoundButton(
                    icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _timerReset();
                    timerController.reset();
                    setState(() {
                      isPlaying = false;
                    });
                  },
                  child: RoundButton(
                    icon: Icons.stop,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}