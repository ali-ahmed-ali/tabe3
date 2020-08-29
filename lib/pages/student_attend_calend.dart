import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_dropdown_list.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class StudentAttendCalendPage extends StatefulWidget {
  @override
  _StudentAttendCalendPageState createState() =>
      _StudentAttendCalendPageState();
}

class _StudentAttendCalendPageState extends State<StudentAttendCalendPage> {
  CalendarController _controller;
  final Map<DateTime, List> absence = {};
  final Map<DateTime, List> holidays = {};

  //5-> Friday 6->Saturday
  List<int> weekend = [];

  bool loading = false;
  List students = [
    {
      "student_id": -1,
      "student_name": lang.text("--  Select Student  --"),
    }
  ];
  Map selectedStudent = {};
  Map userData = {};

  final Repository _repository = new Repository();
  final PrefManager _manager = new PrefManager();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool loadingCal = false;

  @override
  void initState() {
    _manager.get("customer", "{}").then((value) {
      userData = json.decode(value);
      if (userData.containsKey("id") && userData["id"] != null) {
        getStudents();
      }
    });
    _controller = CalendarController();
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
        students.addAll(response["available_student"]);
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

  void getCal(int studentID) async {
    setState(() {
      loadingCal = true;
    });
    Map response = await _repository.getAttendance(studentID);
    setState(() {
      loadingCal = false;
    });
    print('CAl response: $response');
    if (response.containsKey("success") && response["success"]) {
      (response["holidays"] as List).forEach((element) {
        holidays[DateTime.parse(element["date"])] = [element["name"]];
      });
      (response["attendance"] as List).forEach((element) {
        absence[DateTime.parse(element["date"])] = [element["student_name"]];
      });
      (response["official_holidays"] as List).forEach((element) {
        weekend.add(element);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text("Daily attendance")),
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
                            ? selectedStudent["student_id"].toString()
                            : students[0]["student_id"].toString(),
                        onChange: (data) {
                          print('Data: $data');
                          setState(() {
                            selectedStudent = data;
                          });
                          getCal(data["student_id"]);
                        },
                        displayLabel: "student_name",
                        selectedKey: "student_id",
                        label: lang.text("Select student"),
                      ),
                SizedBox(height: 16),
                loadingCal
                    ? Center(
                        child: LoadingWidget(
                          useLoader: true,
                          size: 32,
                        ),
                      )
                    : absence.length > 0 //offdays.isNotEmpty
                        ? _buildCalender()
                        : EmptyWidget(
                            subMessage:
                                lang.text("Please select student to get table"),
                          ),
                SizedBox(
                  height: 16,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 80,
                              child: Text(
                                lang.text("Selected day"),
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 80,
                              child: Text(
                                lang.text("absence"),
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 80,
                              child: Text(
                                lang.text("holiday"),
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 80,
                              child: Text(
                                lang.text("weekend"),
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalender() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            events: holidays,
            formatAnimation: FormatAnimation.scale,
            weekendDays: weekend,
            holidays: absence,
            daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
              color: Colors.grey,
            )),
            initialCalendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
                markersColor: Colors.green,
                holidayStyle: TextStyle(color: Colors.white),
                todayColor: Theme.of(context).primaryColor,
                selectedColor: Theme.of(context).primaryColor,
                todayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white)),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            startingDayOfWeek: StartingDayOfWeek.saturday,
            onDaySelected: (date, events) {
              print(date.toIso8601String());
            },
            builders: CalendarBuilders(
              holidayDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
              selectedDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
              weekendDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.grey),
                  )),
              todayDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            calendarController: _controller,
            locale: lang.currentLanguage,
          )
        ],
      ),
    );
  }
}
