import 'package:get/state_manager.dart';
import 'package:sqflite/sqflite.dart';

import '../db/db_init.dart';

class NotificationListController extends GetxController{
  List notificationList = [];

  @override
  void onInit() {
    getNotificationList();
  }

  Future<void> getNotificationList() async{
    Database db = await DatabaseInit().database;
    notificationList = await db.rawQuery("SELECT * FROM Notification");
    update();
  }

  Future<void> delete(int id) async {
    print("delete : ${id}");
    Database db = await DatabaseInit().database;
    db.rawQuery("DELETE FROM Notification WHERE id=${id}");
    getNotificationList();
    update();
  }
}