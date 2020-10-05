import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/widget/custome_button.dart';

import '../utils/lang.dart';

class StartTabPreview extends StatefulWidget {
  @override
  _StartTabPreviewState createState() => _StartTabPreviewState();
}

class _StartTabPreviewState extends State<StartTabPreview> {
  final List<Map<String, dynamic>> tabs = [
    {
      'title': lang.text('Pay the fees electronically'),
      'image': 'assets/images/3.png',
      'text': lang.text("Pay your son's fees while you are at the home")
    },
    {
      'title': lang.text('Follow the academic path of the student'),
      'image': 'assets/images/1.png',
      'text': lang.text(
          "Know the dates of the tests, your son's level, and the teacher's notes")
    },
    {
      'title': lang.text('Follow up the results of the tests'),
      'image': 'assets/images/2.png',
      'text': lang.text(
          'Know the results of the tests and rank your son among his colleagues')
    }
  ];

  double opacity = 0.0;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        opacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: DefaultTabController(
            length: tabs.length,
            child: Builder(builder: (context) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: TabBarView(
                      children: tabs.map(
                        (value) {
                          return Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 60),
                                  child: Text(
                                    value['title'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 700),
                                    opacity: opacity,
                                    child: Image.asset(
                                      value['image'],
                                      width: 200,
                                      height: 200,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    value['text'],
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: TabPageSelector(
                      indicatorSize: 10,
                      color: Colors.white,
                      selectedColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  CustomButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteName.login);
                    },
                    label: lang.text('Continue'),
                  ),
                  SizedBox(height: 16.0)
                ],
              );
            })));
  }
}
