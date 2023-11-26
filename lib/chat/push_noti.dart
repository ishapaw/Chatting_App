import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'helper.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

String fCMToken = "";

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    fCMToken = (await _firebaseMessaging.getToken())!;

    print("Token ${fCMToken}");

    HelperFunctions.saveTokenSharePreference(fCMToken);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> sendPushNotification(
      String token, String msg, String name) async {
    print("token: ${token}");

    try {
      http.Response response =
          await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAA-AhT_Fo:APA91bHH35lGtqLsXl9cm866FDPiJt3MkHP-llyU8egiqv9TTIucXZsxKc7ptlLAaZHugyWHXyo0H6UBi-H1hEgziwUyGwUhG_qM0WcT58qmIEH1OhQ7KBRP_6tJLfZJ4jQKLcGhpRGU'
              },
              body: jsonEncode(<String, dynamic>{
                "to": token,
                "notification": {"title": name, "body": msg}
              }));

      print("statusCode ${response.statusCode}");
      print("body ${response.body}");
    } catch (e) {
      print("\nsendPushNotifications: $e");
    }
  }
}
