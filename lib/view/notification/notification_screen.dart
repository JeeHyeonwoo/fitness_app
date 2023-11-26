import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/db/db_init.dart';
import 'package:fitnessapp/utils/notifications/notificationlist_controller.dart';
import 'package:fitnessapp/view/notification/widgets/notification_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "/NotificationScreen";

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationListController());
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          elevation: 0,
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
                  color: AppColors.lightGrayColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/icons/back_icon.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: const Text(
            "Notification",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: GetBuilder<NotificationListController>(
          builder: (controller) {
            controller.getNotificationList();
            return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                itemBuilder: ((context, index) {
                  var nObj = controller.notificationList[index] as Map? ?? {};
                  return NotificationRow(
                      nObj: nObj,
                  );
                }),
                separatorBuilder: (context, index) {
                  return Divider(
                    color: AppColors.grayColor.withOpacity(0.5),
                    height: 1,
                  );
                },
                itemCount: controller.notificationList.length) ;
          },
        )
    );
  }
}
