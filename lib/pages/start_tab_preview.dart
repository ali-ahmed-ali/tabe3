import 'package:flutter/material.dart';
import 'package:tabee/pages/login.dart';
import 'package:tabee/translate/lang.dart';

class StartTabPreview extends StatelessWidget {
  final List<Map<String, dynamic>> tabs = [
    {
      'title': Lang().text('سدد الرسوم الكترونيا'),
      'image': 'assets/cash.png',
      'text': Lang().text('سدد رسوم ابنك وانت من بيتك')
    },
    {
      'title': Lang().text('متابعه المسار الاكاديمي للطالب'),
      'image': 'assets/book.png',
      'text':
          Lang().text('معرفه مواعيد الاختبارات ومستوى ابنك و ملاحظات المعلمين')
    },
    {
      'title': Lang().text('متابعه نتائج الاختبارات'),
      'image': 'assets/result.png',
      'text': Lang().text('معرفة نتائج الاختبارات وترتيب ابنك وسط زملائه')
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
                      color: Theme.of(context).accentColor,
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(Lang().text('متابعة')),
                      )),
                ],
              );
            })));
  }
}
