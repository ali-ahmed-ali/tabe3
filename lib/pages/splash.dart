import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:timeago/timeago.dart' as timeago;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PrefManager _manager = new PrefManager();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      init();
    });
    super.initState();
  }

  void init() async {
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
