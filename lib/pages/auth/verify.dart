import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/utils/utils.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/verify_widget.dart';

class VerifyScreen extends StatefulWidget {
  final String type;

  VerifyScreen({this.type = "new"});

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Repository _repository = new Repository();
  PrefManager _manager = new PrefManager();

  String pin = "";

  int fullCountDown = 60;
  int countDown = 60;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {
    countDown = fullCountDown;
    _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        countDown--;
      });
      if (timer.tick >= fullCountDown) {
        timer.cancel();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            lang.text("OTP not received?"),
          ),
          duration: Duration(seconds: 60),
          action: SnackBarAction(
            label: lang.text("Retry"),
            onPressed: resend,
            textColor: Colors.blue,
          ),
        ));
      }
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          lang.text("Verification").toUpperCase(),
          style: TextStyle(
            color: Colors.blue,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Container(
        height: screenSize.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 56.0,
                    ),
                    Image(
                      image:
                          AssetImage('assets/images/img_code_verification.png'),
                      width: 200,
                      height: 200,
                    ),
                    Text(
                      lang.text(
                          "OTP Has been sent to you on your mobile phone. Please enter it below"),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Text(timerFormat(countDown)),
                    Column(
                      children: <Widget>[
//                        GridView.count(
//                          crossAxisCount: 6,
//                          mainAxisSpacing: 10.0,
//                          shrinkWrap: true,
//                          primary: false,
//                          scrollDirection: Axis.vertical,
//                          children: inputs,
//                        ),
                        VerifyWidget(
                          length: 4,
                          keyboardType: TextInputType.number,
                          itemSize: 56.0,
                          onCompleted: (value) {
                            setState(() {
                              pin = value;
                            });
                            verify();
                          },
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        InkWell(
                          onTap: verify,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              lang.text("Verify"),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        InkWell(
                          onTap: resend,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              lang.text("Resend"),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Register for new account
  void verify() async {
    showLoadingDialog(context);
    String mobile = await _manager.get("temp_mobile", "");
    Map response = await _repository.verifyPin(mobile, pin);
    log("response: $response");
    Navigator.pop(context);
    if (response.containsKey("success") && response["success"]) {
      await _manager.set("temp_pin", pin);
      Navigator.pushNamed(context, RouteName.updatePassword);
    }
  }

  void resend() async {
    startTimer();
    showLoadingDialog(context);
    String mobile = await _manager.get("temp_mobile", "");
    Map response = await _repository.sendVerifyPin(mobile);
    log("Response: $response");
    Navigator.pop(context);
  }

  void showSnackBar(String message, Color color, IconData icon,
      [SnackBarAction action]) {
    _scaffoldKey.currentState
        .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(icon, color: Colors.white),
            SizedBox(width: 16.0),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        action: action,
      ),
    );
  }
}
