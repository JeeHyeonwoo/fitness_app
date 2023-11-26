import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/db/db_init.dart';
import 'package:fitnessapp/utils/notifications/notification_controller.dart';
import 'package:fitnessapp/utils/notifications/notificationlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sqflite/sqflite.dart';

class NotificationRow extends StatelessWidget {
  final Map nObj;
  const NotificationRow({Key? key, required this.nObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              nObj["image"].toString(),
              width: 40,
              height: 40,
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
                    nObj["title"].toString(),
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  Text(
                    nObj["time"].toString(),
                    style: TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              )),
          GetBuilder<NotificationListController>(builder: (controller){
            return IconButton(
                onPressed: () {
                  controller.delete(nObj['id']);
                },
                icon: Image.asset(
                  "assets/icons/closed_btn.png",
                  width: 15,
                  height: 15,
                  fit: BoxFit.contain,
                )
            );
          })
        ],
      ),
    );
  }
}
