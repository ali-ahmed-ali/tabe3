import 'package:flutter/material.dart';
import 'package:tabee/pages/start_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color color = Color.fromRGBO(41, 171, 226, 1);
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.white,
        primaryColor: color,
      ),
      home: StartPage(),
    );
  }
}
