import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/calendar/calendar_event_model.dart';
import 'package:fitnessapp/utils/db/db_init.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';


class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // 테스트용 데이터
  Map<DateTime, dynamic> eventSource = {
    /*DateTime(2023, 9, 1): [CalendarEventModel(5, 3000)],
    DateTime(2023, 9, 5) : [CalendarEventModel(5, 3000)],
    DateTime(2023, 9, 15) : [CalendarEventModel(5, 3000)],
    DateTime(2023, 9, 20) : [CalendarEventModel(5, 3000)],
    DateTime(2023, 9, 23) : [CalendarEventModel(5, 3000)],*/
  };
  List<FlSpot> spotData = [
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
    FlSpot(7, 0),
  ];
  List<CalendarEventModel> getEventsForDay(DateTime day) {
    return eventSource[DateTime.parse(day.toString().replaceFirst("Z", ""))] ?? [];
  }

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime foucsedDay = DateTime.now();

  void _pageChangeEvent(DateTime dateTime) async {
    Database database = await DatabaseInit().database;

    DateTime minDt = DateTime(dateTime.year, dateTime.month);
    DateTime maxDt = DateTime(dateTime.year, dateTime.month);

    if (minDt.weekday < 7) {
      minDt = minDt.subtract(Duration(days: minDt.weekday));
    }

    if (dateTime.month < 12) {
      maxDt = DateTime(dateTime.year, dateTime.month + 1);
    } else {
      maxDt = DateTime(dateTime.year + 1, 1, 1);
    }
    maxDt = maxDt.subtract(Duration(days: 1));

    if (maxDt.weekday < 7) {
      maxDt = maxDt.add(Duration(days: 7-maxDt.weekday));
    }else {
      maxDt = maxDt.add(Duration(days:7));
    }


    List<Map<String, dynamic>> result = await database.rawQuery(
        "SELECT dateTime, SUM(count) as count, SUM(useTime) as useTime "
            "FROM (SELECT SUBSTR(dateTime, 1,10) as dateTime, useTime, count "
            "FROM (SELECT * FROM WorkoutRecord WHERE dateTime BETWEEN '${minDt.year}-${minDt.month.toString().padLeft(2,'0')}-${minDt.day.toString().padLeft(2,'0')}' AND '${maxDt.year}-${maxDt.month.toString().padLeft(2,'0')}-${maxDt.day.toString().padLeft(2,'0')}' )) "
            "GROUP BY dateTime "
            "ORDER BY dateTime ASC"
    );

    eventSource = {};

    for(Map<String, dynamic> map in result) {
      setState(() {
        eventSource[DateTime.parse(map['dateTime'])] = [CalendarEventModel(map['count'], map['useTime'])];
      });
    }
  }
  void _searchRange(DateTime dateTime) async{
    Database database = await DatabaseInit().database;
    DateTime minDt = DateTime.now();
    DateTime maxDt = DateTime.now();
    int week = dateTime.weekday;
    if(week < 7) {
      minDt = dateTime.subtract(Duration(days:week));
      maxDt = dateTime.add(Duration(days:7-week));
    }else {
      maxDt = dateTime.add(Duration(days: 7));
    }

    List<Map<String, dynamic>> result = await database.rawQuery(
        "SELECT dateTime, SUM(count) as count, SUM(useTime) as useTime "
            "FROM (SELECT SUBSTR(dateTime, 1,10) as dateTime, useTime, count "
                    "FROM (SELECT * FROM WorkoutRecord WHERE dateTime BETWEEN '${minDt.year}-${minDt.month.toString().padLeft(2,'0')}-${minDt.day.toString().padLeft(2,'0')}' AND '${maxDt.year}-${maxDt.month.toString().padLeft(2,'0')}-${maxDt.day.toString().padLeft(2,'0')}' )) "
            "GROUP BY dateTime "
            "ORDER BY dateTime ASC"
    );

    List<Map<String, dynamic>> result2 =
        await database.rawQuery("SELECT * FROM ObjectiveSettingInfo");
    Map<String, int> objective = {"timer": 900, "count": 50};
    if(result2.isNotEmpty) {
      objective['timer'] = result2[0]['timer'];
      objective['count'] = result2[0]['count'];
    }

    setState(() {
      spotData = [
        FlSpot(1, 0),
        FlSpot(2, 0),
        FlSpot(3, 0),
        FlSpot(4, 0),
        FlSpot(5, 0),
        FlSpot(6, 0),
        FlSpot(7, 0),
      ];

      for(Map<String, dynamic> e in result) {
        DateTime dt = DateTime.parse(e['dateTime']);
        switch(dt.weekday) {
          case 0: // 월요일
            spotData[1] = FlSpot(2, (e['count']/objective['count']) < 1 ? (e['count']/objective['count']) * 100 : 100);
          case 1: // 화
            spotData[2] = FlSpot(3, (e['count']/objective['count']) < 1 ? (e['count']/objective['count']) * 100 : 100);
          case 2: // 수
            spotData[3] = FlSpot(4, (e['count']/objective['count']) < 1 ? (e['count']/objective['count']) * 100 : 100);
          case 3: // 목
            spotData[4] = FlSpot(5, (e['count']/objective['count']) < 1 ? (e['count']/objective['count']) * 100 : 100);
          case 4: // 금
            spotData[5] = FlSpot(6, (e['count']/objective['count']) < 1 ? (e['count']/objective['count']) * 100 : 100);
          case 5: // 토
            spotData[6] = FlSpot(7, (e['count']/objective['count']) < 1 ? (e['count']/objective['count']) * 100 : 100);
          case 6: // 일
            spotData[0] = FlSpot(1, (e['count']/objective['count']) < 1 ? (e['count']/objective['count']) * 100 : 100);
        }
      }
    });
  }
  //"'${minDt.year}-${minDt.month.toString().padLeft(2,'0')}-${minDt.day.toString().padLeft(2,'0')} '"
  //         "AND '${maxDt.year}-${maxDt.month.toString().padLeft(2,'0')}-${maxDt.day.toString().padLeft(2,'0')}'"
  @override
  void initState() {
    _searchRange(DateTime.now());
    _pageChangeEvent(DateTime.now());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: AppColors.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              // pinned: true,
              title: const Text(
                "운동 기록",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: const SizedBox(),
              expandedHeight: media.height * 0.21,
              flexibleSpace: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: media.width * 0.5,
                width: double.maxFinite,
                child: LineChart(
                  LineChartData(
                    /*lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchCallback:
                          (FlTouchEvent event, LineTouchResponse? response) {
                        if (response == null || response.lineBarSpots == null) {
                          return;
                        }
                        if (event is FlTapUpEvent) {
                          final spotIndex =
                              response.lineBarSpots!.first.spotIndex;
                          showingTooltipOnSpots.clear();
                          setState(() {
                            showingTooltipOnSpots.add(spotIndex);
                          });
                        }
                      },
                      mouseCursorResolver:
                          (FlTouchEvent event, LineTouchResponse? response) {
                        if (response == null || response.lineBarSpots == null) {
                          return SystemMouseCursors.basic;
                        }
                        return SystemMouseCursors.click;
                      },
                      getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: Colors.transparent,
                            ),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                    radius: 3,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: AppColors.secondaryColor1,
                                  ),
                            ),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: AppColors.secondaryColor1,
                        tooltipRoundedRadius: 20,
                        getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                          return lineBarsSpot.map((lineBarSpot) {
                            return LineTooltipItem(
                              "${lineBarSpot.x.toInt()} mins ago",
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),*/
                    lineBarsData: lineBarsData1,
                    minY: -0.5,
                    maxY: 110,
                    titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: bottomTitles,
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: rightTitles,
                        )),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 25,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.whiteColor.withOpacity(0.15),
                          strokeWidth: 2,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.grayColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  /*Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor2.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Workout Schedule",
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: RoundButton(
                            title: "Check",
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         const ActivityTrackerView(),
                              //   ),
                              // );
                            },
                          ),
                        )
                      ],
                    ),
                  ),*/
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "전체 기록",
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  TableCalendar(
                    locale: 'ko_KR',
                    daysOfWeekHeight: 30,
                    focusedDay: foucsedDay,
                    firstDay: DateTime.utc(2023, 9, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      weekendTextStyle: TextStyle(color: Colors.red),
                      markerDecoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle
                      )
                    ),
                    availableGestures: AvailableGestures.none,
                    eventLoader: (day) {
                      return getEventsForDay(day);
                    },
                    onPageChanged: (d) {
                      _pageChangeEvent(d);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      _searchRange(focusedDay);
                     setState(() {
                       this.selectedDay = selectedDay;
                       this.foucsedDay = focusedDay;
                     });
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDay, day);
                    },
                  ),
                ],
              ),
            ),
          )),
      ),
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    // lineChartBarData1_2,
  ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: AppColors.whiteColor,
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: spotData,
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: AppColors.whiteColor.withOpacity(0.5),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
    ),
    spots: const [
      FlSpot(1, 80),
      FlSpot(2, 50),
      FlSpot(3, 90),
      FlSpot(4, 40),
      FlSpot(5, 80),
      FlSpot(6, 35),
      FlSpot(7, 60),
    ],
  );

  SideTitles get rightTitles => SideTitles(
    getTitlesWidget: rightTitleWidgets,
    showTitles: true,
    interval: 20,
    reservedSize: 40,
  );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: AppColors.whiteColor,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('일', style: style);
        break;
      case 2:
        text = Text('월', style: style);
        break;
      case 3:
        text = Text('화', style: style);
        break;
      case 4:
        text = Text('수', style: style);
        break;
      case 5:
        text = Text('목', style: style);
        break;
      case 6:
        text = Text('금', style: style);
        break;
      case 7:
        text = Text('토', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}
