import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_dropdown_list.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class StudentAttendCalendPage extends StatefulWidget {
  @override
  _StudentAttendCalendPageState createState() => _StudentAttendCalendPageState();
}

class _StudentAttendCalendPageState extends State<StudentAttendCalendPage> {
  CalendarController _controller;
  final Map<DateTime, List> _holidays = {
    DateTime(2020, 8, 4): ['New Year\'s Day'],
    DateTime(2020, 8, 12): ['Eid al-Fitr'],
    DateTime(2020, 8, 23): ['Eid al-Adha'],
  };
  final Map<DateTime, List> absence = {
    DateTime(2020, 8, 13): ['New Year\'s Day'],
    DateTime(2020, 8, 9): ['Eid al-Fitr'],
    DateTime(2020, 8, 25): ['Eid al-Adha'],
  };
  //5-> Friday 6->Saturday
  List<int> weekend = [
    5,
    6,
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
                    : true//offdays.isNotEmpty
                    ? _buildCalender()
                    : EmptyWidget(
                  subMessage:
                  lang.text("Please select student to get table"),
                ),
                SizedBox(height: 16,),
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
                            child: Container(

                            ),
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
                            child: Container(

                            ),
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
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCalender ()
  {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            events: absence,
            formatAnimation: FormatAnimation.scale,
            weekendDays: weekend,
            holidays: _holidays,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(
                color: Colors.grey,
              )
            ),
            initialCalendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
              markersColor: Colors.green,
                holidayStyle: TextStyle(
                    color: Colors.white
                ),
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0)),
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
          )
        ],
      ),
    );

  }
}
