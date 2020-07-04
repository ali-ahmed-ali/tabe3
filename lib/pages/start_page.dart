import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';

import '../utils/lang.dart';

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
            Expanded(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
            ),
            Container(
              width: _buttonSize,
              height: 40,
              margin: EdgeInsets.only(bottom: 60, right: 20, left: 20),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.sliderPage,
                      ModalRoute.withName(RouteName.splash));
                },
                child: Text(
                  lang.text('Start'),
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
