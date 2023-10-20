import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:fitnessapp/utils/timer/timer_model.dart';
import 'package:flutter/cupertino.dart';

class TimerViewModel with ChangeNotifier {
  final CountDownController controller = CountDownController();
  TimerModel _timerModel = TimerModel();
  TimerModel get timerModel => _timerModel;

  Future<void> _started() async{
    _timerModel.timer = Timer.periodic(Duration(seconds:1),
      (timer) {
        if(_timerModel.totalSecond > 0) {
          _timerModel.totalSecond--;
        }else {
          _stop();
        }
        notifyListeners();
      });
  }

  void _stop() {
    _timerModel.timerStatus = TimerStatus.stop;
    _timerModel.timer?.cancel();
  }

  void toggleClickEvent() {
    print(_timerModel.timerStatus);
    if (_timerModel.timerStatus == TimerStatus.stop ){
      _stop();
    } else if(_timerModel.timerStatus == TimerStatus.run) {
      _started();
    }
  }
}