import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/utils/push_notification.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

const String VERSION = "1.1.0.1";
const String PLAY_STORE_LINK =
    "https://play.google.com/store/apps/details?id=com.moggal.tab3";

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PrefManager _manager = new PrefManager();
  final Repository _repository = new Repository();

  PushNotificationsManager _pushNotificationsManager;

  @override
  void initState() {
    init();
    Future.delayed(Duration(milliseconds: 700), () async {
      await configLang();
      checkForUpdates();
    });
    super.initState();
  }

  void initLang() async {
    initLang() async {
      await lang.init();
      timeago.setLocaleMessages('ar', timeago.ArMessages());
      timeago.setLocaleMessages('en', timeago.EnMessages());
      timeago.setLocaleMessages('tr', timeago.TrMessages());
      AppBuilder.of(context).rebuild();
    }
  }

  Future checkForUpdates() async {
    Map response = await _repository.getVersion();
    if (response.containsKey("success") && response["success"]) {
      if (response.containsKey("Vcode") && response["Vcode"] != VERSION) {
        bool openPlay = await showUpdateDialog(context,
            body: lang.text(
                "New version available in store, do you want to install it?"),
            isRequired: (response["action"] ?? "w") == "b");
        if (openPlay) {
          if (Platform.isAndroid) {
            if (await canLaunch(PLAY_STORE_LINK)) {
              await launch(PLAY_STORE_LINK);
            } else {
              print('Cannot launch google play');
            }
          }
        }
      }
    }
    checkSession();
  }

  void init() async {
    _pushNotificationsManager = PushNotificationsManager(
        context: context,
        getToken: (token) async {
          print('token: $token');
          String oldToken =
              await _manager.get("firebase_notification_token", "");
          Map userData = json.decode(await _manager.get("customer", "{}"));

          if (userData != null &&
              userData.containsKey("id") &&
              oldToken != token) {
            Map response =
                await _repository.updateToken(userData["id"].toString(), token);
            print('update token response: $response');
          }

          await _manager.set("firebase_notification_token", token);
        });
    await _pushNotificationsManager.init();
    await _pushNotificationsManager.subscribeToTopic("test");
  }

  void checkSession() async {
    String token = await _manager.get("token", null);
    String user = await _manager.get("customer", null);
    print('user: $user');
    bool firstLaunch = await _manager.get("firstLaunch", true);
    if (firstLaunch) {
      Navigator.pushReplacementNamed(context, RouteName.startPage);
    } else if (user == null) {
      Navigator.pushReplacementNamed(context, RouteName.login);
    } else {
      Navigator.pushReplacementNamed(context, RouteName.home);
    }
  }

  Future<Null> configLang() async {
    WidgetsFlutterBinding.ensureInitialized();
    await lang.init();
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    AppBuilder.of(context).rebuild();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorDark,
              Colors.black.withOpacity(.5),
              Theme.of(context).primaryColor.withOpacity(.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logowhite.png"))),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
