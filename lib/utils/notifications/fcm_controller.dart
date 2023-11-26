import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;


class FCMController {
  final String _serverKey = "AAAAWlqKePc:APA91bGy12PIOsv6v8zYqcxnT2NV_ptxzTTbVMm0LMdvVvIxfe6uBLEuHsG6zJ7cGdJnvfE1jsAyIQ-FMjAg2ejOO6jRbetH7WWPgi7uZijR_0aOJ_3MtJxhje1RNhmTyVmzQ7SW670n";

  Future<void> sendMessage({
    required String userToken,
    required String title,
    required String body,
}) async {
    http.Response response;

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    try {
      response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey'
          },
          body: jsonEncode({
            'notification': {'title': title, 'body': body, 'sound': 'false'},
            'ttl': '60s',
            "content_available": true,
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "action": '테스트',
            },
            'to': userToken
          })
      );
    } catch (e) {
      print('error $e');
    }
  }
}