import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:tabee/utils/lang.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text("About us")),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              width: 200,
              height: 200,
            ),
            SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey,
              width: double.infinity,
              child: Text(
                lang.text("About us"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
//            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  /*Text(
                lang.text("about_us_long"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              )*/
                  Html(
                data: lang.text("about_us_long"),
                style: {
                  "b": Style(
                    color: Theme.of(context).primaryColorDark,
                  )
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
