import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/utils/push_notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PrefManager _manager = new PrefManager();
  final Repository _repository = new Repository();

  @override
  void initState() {
    init();
    Future.delayed(Duration(seconds: 3), () {
      checkSession();
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

  void init() async {
    PushNotificationsManager(
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
        }).init();
  }

  void checkSession() async {
    await configLang();
    String token = await _manager.get("token", null);
    bool firstLaunch = await _manager.get("firstLaunch", true);
    if (firstLaunch) {
      Navigator.pushNamed(context, RouteName.startPage);
    } else if (token == null) {
      Navigator.pushNamed(context, RouteName.login);
    } else {
      Navigator.pushNamed(context, RouteName.home);
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
