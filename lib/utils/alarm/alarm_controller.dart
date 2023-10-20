import 'dart:async';

import 'package:get/get.dart';

class AlarmController extends GetxController {
  // final FlutterReactiveBle _ble = FlutterReactiveBle();

  RxInt totalSeconds = (15 * 60).obs;
  RxInt tmpSeconds = (15 * 60).obs;
  Timer? _timer;
  Rx<AlarmStatus> status = AlarmStatus.stop.obs;

  void setAlarmTime({int hour = 0, int minute = 15, int seconds = 0}) {
    totalSeconds.value = (hour * 60 * 60) + (minute * 60) + seconds;
    tmpSeconds.value = totalSeconds.value;  //
    _timer?.cancel();
    status.value = AlarmStatus.run;
  }

  Future<void> _started() async {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if ( totalSeconds > 0) {
        totalSeconds--;
      } else {
        status.value = AlarmStatus.run;
        totalSeconds.value = tmpSeconds.value;
        _timer?.cancel();
      }
    });
  }

  void _pause() {//
    _timer?.cancel();
  }

  void toggleButtonState() {
    if ( status.value == AlarmStatus.run) {
      _started();
    }else {
      _pause();
    }
    status.value = (status.value == AlarmStatus.stop) ? AlarmStatus.run : AlarmStatus.stop;
  }

}

enum AlarmStatus {
  run,
  pause,
  stop
}
