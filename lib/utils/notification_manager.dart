import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';

class NotificationManager {
  BuildContext _context;

  NotificationManager._();

  static final _inctance = NotificationManager._();

  factory NotificationManager() => _inctance;

  bool _initialized = false;

  Repository _repository = new Repository();

  final FlutterLocalNotificationsPlugin _notification =
      new FlutterLocalNotificationsPlugin();

  Future onSelectNotification(String payload) async {
    // When user clicks notification
    log("onSelectNotification: $payload");
    await Navigator.pushNamed(_context, RouteName.splash);
  }

  Future<void> init(BuildContext context) async {
    _context = context;
    if (!_initialized) {
      var initSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      var initSettingsIOS = IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: false,
          requestSoundPermission: true,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {});
      var initSettings =
          InitializationSettings(initSettingsAndroid, initSettingsIOS);
      await _notification.initialize(initSettings,
          onSelectNotification: onSelectNotification);
    }
  }

  void showNotification(Map<String, dynamic> message) async {
    String title = message["notification"]["title"] ?? "NotificationTitle";
    String body = message["notification"]["body"] ?? "NotificationBody";
    Map payload = message["data"] ?? "Payload"; // Any additional data

    var action = AndroidNotificationChannelAction.CreateIfNotExists;

    String groupKey = 'CHINGUITEL_OFFERS';
    String groupChannelId = 'OFFERS';
    String groupChannelName = 'Offer chnnel';
    String groupChannelDescription = 'This channel for ChinguitelApp';

    var androidDetails = AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.Default,
        priority: Priority.High,
        enableVibration: true,
        groupKey: groupKey,
        playSound: true,
        showWhen: true,
        enableLights: true);
    var iOSDetails = IOSNotificationDetails();
    var notificationDetails = NotificationDetails(androidDetails, iOSDetails);
    await _notification.show(0, title, body, notificationDetails,
        payload: json.encode(payload));
  }

  void showNotificationWithPicture(Map message) async {
    print('showNotificationWithPicture: $message');
    String title = message["notification"]["title"] ?? "NotificationTitle";
    String body = message["notification"]["body"] ?? "NotificationBody";
    String url = message["notification"]["image"] ?? "";
    Map payload = message["data"] ?? "Payload"; // Any additional data

    String groupKey = 'CHINGUITEL_OFFERS';
    String groupChannelId = 'OFFERS';
    String groupChannelName = 'Offer chnnel';
    String groupChannelDescription = 'This channel for ChinguitelApp';

    var bigPicturePath = "";
    var bigPictureStyleInformation = new BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      contentTitle: title,
      summaryText: body,
      htmlFormatSummaryText: true,
    );

    var androidDetails = AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.Default,
        priority: Priority.High,
        enableVibration: true,
        groupKey: groupKey,
        playSound: true,
        showWhen: true,
        enableLights: true,
        styleInformation: bigPictureStyleInformation,
        largeIcon: FilePathAndroidBitmap('@mipmap/ic_launcher'));

    var iOSDetails = IOSNotificationDetails();
    var notificationDetails = NotificationDetails(androidDetails, iOSDetails);

    _notification.show(0, title, body, notificationDetails,
        payload: json.encode(payload));
  }
}
