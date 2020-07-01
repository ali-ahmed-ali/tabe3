import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/theme_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      builder: (context) {
        return MaterialApp(
          title: 'Tabe3',
          theme: themeData(platformDarkMode: false),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Router.generateRoute,
          initialRoute: RouteName.startPage,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        );
      },
    );
  }
}
