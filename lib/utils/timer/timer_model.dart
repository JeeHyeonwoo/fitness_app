import 'dart:async';

import 'package:flutter/animation.dart';

// 싱글톤
class TimerModel {

  int totalSecond = 15 * 60;
  Timer? timer;
  TimerStatus timerStatus = TimerStatus.stop;

  TimerModel._privateConstructor();

  static TimerModel _timerModel = TimerModel._privateConstructor();

  factory TimerModel(){
    return _timerModel;
  }
}

enum TimerStatus {
  run,
  stop
}