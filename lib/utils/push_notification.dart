import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/utils/notification_manager.dart';
import 'package:tabee/utils/pref_manager.dart';

class PushNotificationsManager {
  final BuildContext context;
  final Function(String value) getToken;

//  PushNotificationsManager._();
  PushNotificationsManager({this.context, this.getToken});

//  factory PushNotificationsManager() => _instance;
//  static final PushNotificationsManager _instance =
//      PushNotificationsManager._();
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  bool _initialized = false;

  PrefManager _manager = new PrefManager();
  static NotificationManager _notificationManager = new NotificationManager();

  static Future<dynamic> onBackgroundMessageHandler(
      Map<String, dynamic> message) {
    print('onBackgroundMessageHandler: $message');
    _notificationManager.showNotification(message);
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    return Future<void>.value();
  }

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permissions
      if (Platform.isIOS) {
        _firebaseMessaging.requestNotificationPermissions(
            IosNotificationSettings(sound: true, badge: true, alert: true));
        _firebaseMessaging.onIosSettingsRegistered
            .listen((IosNotificationSettings settings) {});
      }

      await _notificationManager.init(context);

      _firebaseMessaging.getToken().then((value) => getToken(value));

//      if (await _manager.get("token", "") != "")
//        _firebaseMessaging.subscribeToTopic("offers");
//      else
//        _firebaseMessaging.unsubscribeFromTopic("offers");

      _firebaseMessaging.configure(
        onMessage: (message) async {
          onBackgroundMessageHandler(message);
          print('onMessage: $message');
          _notificationManager.showNotificationWithPicture(message);
        },
        onLaunch: (message) async {
          print('onLaunch: $message');
          await Navigator.pushNamed(context, RouteName.splash);
        },
        onResume: (message) async {
          print('onResume: $message');
          Navigator.pushNamed(context, RouteName.splash);
        },
        onBackgroundMessage: onBackgroundMessageHandler,
      );

      // Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      await PrefManager().set("firebaseToken", token);
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
