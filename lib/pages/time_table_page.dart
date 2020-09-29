import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_dropdown_list.dart';
import 'package:tabee/widget/custom_table.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class TimeTablePage extends StatefulWidget {
  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  List<Widget> columns = [
    Container(),
    Text(lang.text("Lecture") + " 1"),
    Text(lang.text("Lecture") + " 2"),
    Text(lang.text("Lecture") + " 3"),
    Text(lang.text("Lecture") + " 4"),
    Text(lang.text("Lecture") + " 5"),
    Text(lang.text("Lecture") + " 6"),
    Text(lang.text("Lecture") + " 7"),
    Text(lang.text("Lecture") + " 8"),
  ];
  List<Widget> mainColumns = [
    Container(),
    Text(lang.text("Lecture") + " 1"),
    Text(lang.text("Lecture") + " 2"),
    Text(lang.text("Lecture") + " 3"),
    Text(lang.text("Lecture") + " 4"),
    Text(lang.text("Lecture") + " 5"),
    Text(lang.text("Lecture") + " 6"),
    Text(lang.text("Lecture") + " 7"),
    Text(lang.text("Lecture") + " 8"),
  ];
  List<Widget> days = [];
  List<List> data = [];

  bool loading = false;
  List students = [
    {
      "student_id": -1,
      "student_name": lang.text("-- Select Student --"),
    }
  ];

  List classes = [
    {
      "id": -1,
      "name": lang.text("-- Select Class --"),
    }
  ];
  Map selectedStudent = {};
  Map selectedClass = {};
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
        if (userData["user_type"] == "P")
          getStudents();
        else
          getClasses();
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
        students.addAll(response["result"]["available_student"]);
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

  void getClasses() async {
    setState(() {
      loading = true;
    });
    Map response = await _repository.getClasses();
    setState(() {
      loading = false;
    });
    print('students response: $response');
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        classes.addAll(response["data"]);
        if (students.isNotEmpty) selectedClass = classes[0];
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
      columns = [];
    });
    Map response = await _repository.getTimeTable(studentID);
    setState(() {
      loadingTable = false;
    });
    print(
        'time table response: $response'); ///////////////////////////////////////////////
    int max = 0;
    if (response.containsKey("success") && response["success"]) {
      response["timetable"].forEach((key, value) {
        setState(() {
          days.add(new Text(lang.text(key.toString())));
          max = (value as List).length > max ? (value as List).length : max;
          print('MAX >>>>>>>>>>>> $max');
        });
      });

      setState(() {
        Map<String, dynamic> allDays = response["timetable"];
        List<List> allDaysList = [];
        allDays.forEach((key, value) {
          allDaysList.add(value);
        });
        int maxSubject = 0;
        for (int i = 0; i < 7; i++) {
          print('Max subject count : $maxSubject');
          if (allDaysList.elementAt(i).length > maxSubject) {
            maxSubject = allDaysList.elementAt(i).length;
          }
        }

        maxSubject = response["max_lec"];

        for (int i = 0; i <= maxSubject; i++) {
          columns.add(mainColumns.elementAt(i));
        }
        for (int i = 0; i < 7; i++) {
          List day = allDaysList.elementAt(i);

          List newdayvalue = [];
          for (int k = 0; k < maxSubject; k++) {
            if (k >= day.length) {
              //data.elementAt(i).removeAt(k);
              newdayvalue.add(Text("-"));
            } else {
              //data.elementAt(i).removeAt(k);
              newdayvalue.add(InkWell(
                onTap: () {
                  openChatWithTeacher(day.elementAt(k));
                },
                child: Column(
                  children: <Widget>[
                    Text(day.elementAt(k)['subject_name']),
                    SizedBox(height: 4),
                    Text(day.elementAt(k)['teacher'] ?? ""),
                  ],
                ),
              ));
            }
          }
          data.add(newdayvalue);
        }
      });
    }
  }

  void openChatWithTeacher(Map subjectData) async {
    bool openChat = await showCustomDialog(context,
        title: Text(
          lang.text("Contact with teacher"),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          children: <Widget>[
            Text(lang.text("Start conversation with teacher")),
            SizedBox(height: 8),
            Text("${lang.text("Teacher name")}:  ${subjectData["teacher"]}"),
          ],
        ),
        positiveLabel: Text(
          lang.text("Start chat"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        positiveColor: Theme.of(context).primaryColor,
        negativeLabel: Text(
          lang.text("Dismiss"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        negativeColor: Colors.grey[400]);
    print('openChat: $openChat');
    if (openChat) {
      Navigator.pushNamed(context, RouteName.conversations);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text("Daily school schedule")),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 16),
              loading
                  ? Container(
                      height: 32,
                      child: LoadingWidget(useLoader: true, size: 24),
                    )
                  : userData["user_type"] == "P"
                      ? CustomDropdownList(
                          labels: students,
                          selectedId: selectedStudent != null
                              ? selectedStudent["student_id"].toString()
                              : students[0]["student_id"].toString(),
                          onChange: (data) {
                            print('Data: $data');
                            setState(() {
                              selectedStudent = data;
                            });
                            getTimeTable(data["student_id"]);
                          },
                          displayLabel: "student_name",
                          selectedKey: "student_id",
                        )
                      : CustomDropdownList(
                          labels: classes,
                          selectedId: selectedStudent != null
                              ? selectedStudent["id"].toString()
                              : students[0]["id"].toString(),
                          onChange: (data) {
                            print('Data: $data');
                            setState(() {
                              selectedStudent = data;
                            });
                            getClassStudents(data["id"]);
                          },
                          displayLabel: "name",
                          selectedKey: "id",
                          label: lang.text("Select class"),
                        ),
              SizedBox(height: 16),
              loadingTable
                  ? Flexible(
                      child: LoadingWidget(
                        useLoader: true,
                        size: 64,
                      ),
                    )
                  : data.isNotEmpty
                      ? userData["user_type"] == "P"
                          ? Container(
                              child: getParentView(),
                            )
                          : Container()
                      : selectedStudent["student_id"] != -1
                          ? EmptyWidget(
                              subMessage: lang
                                  .text("Please select student to get table"),
                            )
                          : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getParentView() {
    return CustomTable(
      title: lang.text("Daily school schedule"),
      data: data,
      columnData: columns,
      firstColumnData: days,
      columnSpacing: 16,
      divider: 0,
    );
  }

  Widget getTeacherView() {
    return ListView.builder(itemBuilder: (context, index) {
      return ListTile();
    });
  }

  void getClassStudents(int classId) async {}
}
