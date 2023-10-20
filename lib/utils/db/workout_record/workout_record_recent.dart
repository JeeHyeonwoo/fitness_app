import 'dart:async';

import 'package:fitnessapp/utils/db/db_init.dart';

import 'package:sqflite/sqflite.dart';

class WorkoutRecordRecent {
  int objectiveTime = 900;
  int objectiveCount = 50;
  int useTime = 0;
  int useCount = 0;

  static final WorkoutRecordRecent _WorkoutRecordRecent = WorkoutRecordRecent._privateConstructor();
  WorkoutRecordRecent._privateConstructor();

  factory WorkoutRecordRecent() {
    return _WorkoutRecordRecent;
  }

  final StreamController<Map<String, dynamic>> _workoutRecordStreamController = StreamController();

  Stream<Map<String, dynamic>> get stream => _workoutRecordStreamController.stream;

  // DB Update 알림
  Future<void> notify() async{
    Database _db = await DatabaseInit().database;
    DateTime now = DateTime.now();

    // 목표량
    var result = await _db.rawQuery('SELECT * FROM ObjectiveSettingInfo where id=1');

    if (result.isNotEmpty) {
      objectiveTime = result.first['timer'] as int;
      objectiveCount = result.first['count'] as int;
    }

    // 사용 시간 및 사용 횟수
    var workoutRecordList = await _db.rawQuery("SELECT * FROM WorkoutRecord WHERE dateTime LIKE '${now.year.toString() + "-" + now.month.toString().padLeft(2,'0') + "-" + now.day.toString().padLeft(2,'0')}%'");

    if (workoutRecordList.isNotEmpty) {
      for(Map<String, dynamic> record in workoutRecordList) {
        useCount += (record['count'] as int);
        useTime += (record['useTime'] as int);
      }
    }

    _workoutRecordStreamController.add({
      'timerProgress': double.parse((useTime/objectiveTime).toStringAsFixed(1)),
      'countProgress': double.parse((useCount/objectiveCount).toStringAsFixed(1))
    });

    useCount = 0;
    useTime = 0;
  }
}