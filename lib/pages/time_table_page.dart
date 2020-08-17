import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/widget/custom_table.dart';

class TimeTablePage extends StatefulWidget {
  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  List<Widget> columns = [
    Container(),
    Text(lang.text("Lecture 1")),
    Text(lang.text("Lecture 2")),
    Text(lang.text("Lecture 3")),
    Text(lang.text("Lecture 4")),
    Text(lang.text("Lecture 5")),
    Text(lang.text("Lecture 6")),
    Text(lang.text("Lecture 7")),
    Text(lang.text("Lecture 8")),
  ];
  List<Widget> days = [
    Text(lang.text("Sat")),
    Text(lang.text("Sun")),
    Text(lang.text("Mon")),
    Text(lang.text("Tue")),
    Text(lang.text("Wed")),
    Text(lang.text("Thu")),
    Text(lang.text("Fri")),
  ];
  List data = [
    [
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
    ],
    [
      Center(child: Text(lang.text("French"))),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
    ],
    [
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
    ],
    [
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
    ],
    [
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
    ],
    [
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
    ],
    [
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
    ],
    [
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
      Text(lang.text("French")),
    ],
  ];

  @override
  void initState() {
    super.initState();
  }

  void init() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text("Weekly course schedule")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CustomTable(
                  title: lang.text("Weekly course schedule"),
                  data: data,
                  columnData: columns,
                  firstColumnData: days,
                  columnSpacing: 16,
                  divider: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
