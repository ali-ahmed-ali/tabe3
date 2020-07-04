import 'package:flutter/material.dart';
import '../utils/lang.dart';

class StartTabPreview extends StatelessWidget {
  final List<Map<String, dynamic>> tabs = [
    {
      'title': lang.text('Pay the fees electronically'),
      'image': 'assets/images/cash.png',
      'text': lang.text('Pay your son\'s fees while you are at home')
    },
    {
      'title': lang.text('Follow the academic path of the student'),
      'image': 'assets/images/book.png',
      'text':
          lang.text('Know the dates of the tests, your son\'s level, and the teachers\' notes')
    },
    {
      'title': lang.text('Follow up the results of the tests'),
      'image': 'assets/images/result.png',
      'text': lang.text('Know the results of the tests and rank your son among his colleagues')
    }
  ];
  @override
  Widget build(BuildContext context) {
    double _buttonSize = MediaQuery.of(context).size.width;
    return Scaffold(
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: Image.asset(
                                    value['image'],
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    value['text'],
                                    textAlign: TextAlign.center,
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
                  Container(
                      height: 40,
                      width: _buttonSize,
                      margin: EdgeInsets.only(
                        bottom: 40,
                        top: 10,
                        left: 20,
                        right: 20,
                      ),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            'login'
                          );
                        },
                        child: Text(lang.text('Continue'),style: TextStyle(color: Colors.white),),
                      )),
                ],
              );
            })));
  }
}
