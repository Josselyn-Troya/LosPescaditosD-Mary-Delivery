import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/users_provider.dart';
import 'package:http/http.dart' as http;

class NotificationProvider {

/// Create a [AndroidNotificationChannel] for heads up notifications
 AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

 void initNotifications() async {
  channel = const AndroidNotificationChannel(
   'high_importance_channel', // id
   'High Importance Notifications', // title
   'This channel is used for important notifications.', // description
   importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
   alert: true,
   badge: true,
   sound: true,
  );
 }

 void onMessageListener() {
  //recibe las notificaciones en segundo plano
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage message) {
   if (message != null) {
    print('Nueva notificación: $message');
   }
  });
  //recibe las notificaciones en primer plano
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
   RemoteNotification notification = message.notification;
   AndroidNotification android = message.notification?.android;
   if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
     notification.hashCode,
     notification.title,
     notification.body,
     NotificationDetails(
      android: AndroidNotificationDetails(
       channel.id,
       channel.name,
       channel.description,
       // TODO add a proper drawable resource to android, for now using
       //      one that already exists in example app.
       icon: 'launch_background',
      ),
     ),
    );
   }
  });
 //cuando presionamos sobre la notificación
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
   print('A new onMessageOpenedApp event was published!');
  });
 }

 void saveToken(User user, BuildContext context) async {
  String token = await FirebaseMessaging.instance.getToken();
  UsersProvider usersProvider = new UsersProvider();
  usersProvider.init(context, sessionUser: user);
  usersProvider.updateNotification(user.id, token);
 }

 Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async {
  //ruta que permite hacer la peticion para enviar notificaciones
  Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');
  await http.post(uri, headers: <String, String>{
   'Content-Type': 'application/json',
   'Authorization': 'key=AAAA2ZUuH9U:APA91bGwVejLR2o2Fx2-GyOdDx66F7yuEu_oIWncZ96DmWnzUVrFIynFcciERQ_1TQCzms5zAgdYaNSxZDur5qjsDxMtSY8XcVA6KEFADZKAPRspXmSvCqoSEVEnMtiatJhvuVF0Jre3'
  },
   body: jsonEncode(<String, dynamic>{
    'notification': <String, dynamic>{
      'body': body,
     'title': title
    },
    'priority': 'high',
    'ttl': '4500s',
    'data': data,
    'to': to
   })
  );
 }


 Future<void> sendMultipleMessage(List<String> toList, Map<String, dynamic> data, String title, String body) async {
  //ruta que permite hacer la peticion para enviar notificaciones
  Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');
  await http.post(uri, headers: <String, String>{
   'Content-Type': 'application/json',
   'Authorization': 'key=AAAA2ZUuH9U:APA91bGwVejLR2o2Fx2-GyOdDx66F7yuEu_oIWncZ96DmWnzUVrFIynFcciERQ_1TQCzms5zAgdYaNSxZDur5qjsDxMtSY8XcVA6KEFADZKAPRspXmSvCqoSEVEnMtiatJhvuVF0Jre3'
  },
   body: jsonEncode(<String, dynamic>{
    'notification': <String, dynamic>{
      'body': body,
     'title': title
    },
    'priority': 'high',
    'ttl': '4500s',
    'data': data,
    'registration_ids': toList
   })
  );
 }
}