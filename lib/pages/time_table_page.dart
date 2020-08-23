import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_dropdown_list.dart';
import 'package:tabee/widget/custom_table.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

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
//      Text(lang.text("French")),
//      Text(lang.text("French")),
//      Text(lang.text("French")),
//      Text(lang.text("French")),
//      Text(lang.text("French")),
      Text(lang.text("Dsfsdfsdfsd")),
    ],
  ];

  bool loading = false;
  List students = [];
  Map selectedStudent = {};
  Map userData = {};

  final Repository _repository = new Repository();
  final PrefManager _manager = new PrefManager();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool loadingTable = false;

  @override
  void initState() {
    _manager.get("customer", "{}").then((value) {
      userData = json.decode(value);
      if (userData.containsKey("id") && userData["id"] != null) {
        getStudents();
      }
    });
    super.initState();
  }

  void getStudents() async {
    setState(() {
      loading = true;
    });
    Map response =
        await _repository.getStudents(int.parse(userData["id"].toString()));
    setState(() {
      loading = false;
    });
    print('students response: $response');
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        students = response["available_student"];
        if (students.isNotEmpty) selectedStudent = students[0];
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          response["message"],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ));
    }
  }

  void getTimeTable(int studentID) async {
    setState(() {
      loadingTable = true;
    });
    setState(() {
      days = [];
      data = [];
    });
    Map response = await _repository.getTimeTable(studentID);
    setState(() {
      loadingTable = false;
    });
    print('time table response: $response');
    int max = 0;
    if (response.containsKey("success") && response["success"]) {
      response["timetable"].forEach((key, value) {
        setState(() {
          days.add(new Text(key.toString()));
          max = (value as List).length > max ? (value as List).length : max;
          print('MAX >>>>>>>>>>>> $max');
        });
      });
      response["timetable"].forEach((key, value) {
        setState(() {
          /*
          data.add((response["timetable"][key] as List)
              .map((e) => Text(e.toString()))
              .toList());

          print('############ DAYS: $days');
          print('############ DATA: $data');*/

          List<Widget> temp = [];
          columns = [];
          for (int i = 0; i < max; i++) {
            columns.add(new Text("Lec: $i"));
            if ((value as List).length - 1 < i) {
              temp.add(new Text(value.toString()));
            } else {
              temp.add(new Container(
                color: Colors.grey,
              ));
            }
          }
          data.add(temp);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text("Daily school schedule")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                loading
                    ? Container(
                        height: 64,
                        child: LoadingWidget(useLoader: true, size: 24),
                      )
                    : CustomDropdownList(
                        labels: students,
                        selectedId: selectedStudent != null
                            ? selectedStudent["id"].toString()
                            : students[0]["id"].toString(),
                        onChange: (data) {
                          print('Data: $data');
                          setState(() {
                            selectedStudent = data;
                          });
                          getTimeTable(data["student_id"]);
                        },
                        displayLabel: "student_name",
                        selectedKey: "student_id",
                        label: lang.text("Select student"),
                      ),
                SizedBox(height: 16),
                loadingTable
                    ? Center(
                        child: LoadingWidget(
                          useLoader: true,
                        ),
                      )
                    : data.isNotEmpty
                        ? CustomTable(
                            title: lang.text("Daily school schedule"),
                            data: data,
                            columnData: columns,
                            firstColumnData: days,
                            columnSpacing: 16,
                            divider: 0,
                          )
                        : EmptyWidget(
                            subMessage:
                                lang.text("Please select student to get table"),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
