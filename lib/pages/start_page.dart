import 'package:flutter/material.dart';
import 'package:tabee/pages/start_tab_preview.dart';
import 'package:tabee/translate/lang.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _buttonSize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Image.asset('assets/logo.png')),
            Container(
              width: _buttonSize,
              height: 40,
              margin: EdgeInsets.only(bottom: 60, right: 20,left: 20),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StartTabPreview()));
                },
                child: Text(
                  Lang().text('Start'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
