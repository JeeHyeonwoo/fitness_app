import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnessapp/utils/db/db_init.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  @override
  void onInit() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );
    print(settings.authorizationStatus);
    _getToken();
    _onMessage();
    super.onInit();
  }

  void _getToken() async{
    String? token = await messaging.getToken();
    try {
      print("token: ${token}");
    } catch (e) { }
  }

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _onMessage() async{
    // 1. Main Chanel 설정
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 2. plugin init
    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings()));

    FirebaseMessaging.onMessage.listen((message) async{
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic>? jsonData;
      if (notification != null && android != null) {
        jsonData = jsonDecode(notification.body!);
        print(jsonData);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          jsonData!['title'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description
            )
          )
        );

        Database _db = await DatabaseInit().database;
        await _db.rawQuery("INSERT INTO Notification (image, title, time)"
            " VALUES ('assets/images/Workout${Random().nextInt(3) + 1}.png', '${jsonData['title']}', '${jsonData['time']}')");
      }

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.body}');
      }
    });

  }

}