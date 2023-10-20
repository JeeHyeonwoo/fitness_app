import 'package:fitnessapp/common_widgets/round_button.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/db/objective_setting_info/objective_setting_info_model.dart';
import 'package:fitnessapp/utils/db/objective_setting_info/objective_setting_info_provider.dart';
import 'package:fitnessapp/utils/db/workout_record/workout_record_recent.dart';
import 'package:fitnessapp/utils/widget/time_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/db/db_init.dart';
import '../../utils/timer/timer_view_model.dart';

class ObjectiveScreen extends StatefulWidget {
  static String routeName = "/ObjectiveScreen";
  const ObjectiveScreen({Key? key}) : super(key: key);

  @override
  State<ObjectiveScreen> createState() => _ObjectiveScreenState();
}

class _ObjectiveScreenState extends State<ObjectiveScreen>{
  late DateTime _dateTime;
  int _count = 50;
  int _totalSecond = 0;
  WorkoutRecordRecent _workoutRecordRecent = WorkoutRecordRecent();

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;

    void _showRegisterDialog(BuildContext context) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx){
            return AlertDialog(
              content: const Text("저장되었습니다", style: TextStyle(fontWeight: FontWeight.w700, fontFamily: "Poppins"), textAlign: TextAlign.center ),
            );
          });
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        title: const Text(
          "목표 설정",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/icons/back_icon.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("오늘보다 더 나은 내일을 위해", style: TextStyle(color: AppColors.midGrayColor, fontSize: 15,),),
                          Text("목표를 만들어보세요", style: TextStyle(color: AppColors.blackColor, fontSize: 23, fontFamily: "Poppins", fontWeight: FontWeight.w700,),)
                        ],),
                    ],),
              ),
              Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: const Text("시간 설정", style: TextStyle(color: AppColors.blackColor, fontSize: 21, fontFamily: "Poppins", fontWeight: FontWeight.w700),),
                        ),
                      ),
                      TimePickerSpinner(
                          isShowSeconds: true,
                          normalTextStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.black
                          ),
                          highlightedTextStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          isForce2Digits: true,
                          spacing: 40,
                          onTimeChange: (time) {
                            setState(() {
                              _totalSecond = (time.hour * 60 * 60) + (time.minute * 60) + (time.second);
                            });
                          },
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: const Text("횟수 설정", style: TextStyle(color: AppColors.blackColor, fontSize: 21, fontFamily: "Poppins", fontWeight: FontWeight.w700),),
                        ),
                      ),
                      Center(
                        child: NumberPicker(
                          minValue: 0,
                          maxValue: 10000,
                          step: 10,
                          selectedTextStyle: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 30,
                          ),
                          value: _count,
                          onChanged: (value) => setState(() {
                            _count = value;
                          }),
                        ),
                      ),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                        children: [
                          RoundButton(title: "저장",type: RoundButtonType.primaryBG, onPressed: () async {
                            DatabaseInit dbInit = DatabaseInit();
                            Database database = await dbInit.database;
                            ObjectiveSettingInfo info = ObjectiveSettingInfo(
                              id: 1,
                              timer: _totalSecond,
                              count: _count,
                            );
                            var result = await database.rawQuery('SELECT * FROM ObjectiveSettingInfo where id=1');
                            if (result.isNotEmpty) {
                              print("디비 업데이트");
                              await database.update("ObjectiveSettingInfo", info.toMap(), where: "id = 1");
                            }else {
                              print("생성");
                              await database.insert("ObjectiveSettingInfo", info.toMap());
                            }
                            _workoutRecordRecent.notify();
                            _showRegisterDialog(context);
                            await Future.delayed(Duration(seconds: 1));
                            Navigator.of(context).pop();
                          })
                        ]
                    ),
                  ),
              ),
              ]
            ),
          ),
    )
    );
  }
}