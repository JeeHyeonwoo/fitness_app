import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/db/db_init.dart';
import 'package:fitnessapp/view/profile/widgets/title_subtitle_cell.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../common_widgets/round_button.dart';
import '../../utils/db/member/member.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool positive = false;
  String? name;
  String? height;
  String? weight;
  String? age;

  @override
  void initState() {
    super.initState();
    getMemberInfo();
  }

  void getMemberInfo() async {
    Database _db = await DatabaseInit().initDB();
    List<Map<String, dynamic>> result = await _db.rawQuery(
        "SELECT * FROM Member WHERE id = 1");

    print("result: ${result}");

    if (result.first.isNotEmpty) {
      setState(() {
        name = result.first['name'].toString();
        height = result.first['height'].toString() + "cm";
        weight = result.first['weight'].toString() + "kg";
        // age = (DateTime.now().year - DateFormat("yyyymmdd").parse(result.first['birth']).year).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(Member());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "설정",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: GetBuilder<Member>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "assets/images/user.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.name ?? "게스트",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 25,
                        child: RoundButton(
                          title: "수정",
                          type: RoundButtonType.primaryBG,
                          onPressed: () {
                            Navigator.pushNamed(context, SignupScreen.routeName);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TitleSubtitleCell(
                          title: controller.height?.toString() ?? "-",
                          subtitle: "키",
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TitleSubtitleCell(
                          title: controller.weight?.toString() ?? "-",
                          subtitle: "몸무게",
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TitleSubtitleCell(
                          title: "-",
                          subtitle: "나이",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 2)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "알림",
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset("assets/icons/p_notification.png",
                                    height: 15, width: 15, fit: BoxFit.contain),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    "보호자 알림 서비스",
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                CustomAnimatedToggleSwitch<bool>(
                                  current: positive,
                                  values: [false, true],
                                  dif: 0.0,
                                  indicatorSize: Size.square(30.0),
                                  animationDuration:
                                  const Duration(milliseconds: 200),
                                  animationCurve: Curves.linear,
                                  onChanged: (b) => setState(() => positive = b),
                                  iconBuilder: (context, local, global) {
                                    return const SizedBox();
                                  },
                                  defaultCursor: SystemMouseCursors.click,
                                  onTap: () => setState(() => positive = !positive),
                                  iconsTappable: false,
                                  wrapperBuilder: (context, global, child) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                            left: 10.0,
                                            right: 10.0,

                                            height: 30.0,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: AppColors.secondaryG),
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30.0)),
                                              ),
                                            )),
                                        child,
                                      ],
                                    );
                                  },
                                  foregroundIndicatorBuilder: (context, global) {
                                    return SizedBox.fromSize(
                                      size: const Size(10, 10),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black38,
                                                spreadRadius: 0.05,
                                                blurRadius: 1.1,
                                                offset: Offset(0.0, 0.8))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  /*Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              )*/
                ],
              );
            },
          ),
          )
        ),
      );
  }
}
