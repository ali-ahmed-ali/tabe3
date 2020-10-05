import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/pages/student_exams.dart';
import 'package:tabee/pages/student_result.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_dropdown_list.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class ExamsPage extends StatefulWidget {
  @override
  _ExamsPageState createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  final Repository _repository = new Repository();
  final PrefManager _manager = new PrefManager();

  bool loading = false;

  Map userData = {};

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

  List exams = [];

  Map selectedStudent = {};
  Map selectedClass = {};

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
        students.addAll((response["result"]["available_student"]));
        selectedStudent = students[0];
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
    AppBuilder.of(context).rebuild();
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
        classes.addAll(response["result"]);
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

  void getExams(int studentID) async {
    exams.clear();
    showLoadingDialog(context);
    Map response = await _repository.getExams(studentID);
    print('Exam response: $response');
    Navigator.pop(context);
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        exams = response["exams"] as List;
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(response["msg"]),
      ));
    }
  }

  void getClassStudents(int classId) async {
    students.clear();
    showLoadingDialog(context);
    Map response = await _repository.getClassStudents(classId);
    Navigator.pop(context);
    print('classes response: $response');
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        students = response["result"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Students: $students');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(lang.text("Exams")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8),
              /*Text(
                lang.text(
                    "Please choose a student to see which exams he is sitting for"),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),*/
              SizedBox(height: 8),
              loading
                  ? Container(
                      height: 64,
                      child: LoadingWidget(useLoader: true, size: 24),
                    )
                  : userData["user_type"] == "P"
                      ? CustomDropdownList(
                          labels: students,
                          onChange: (data) {
                            print('Data: $data');
                            setState(() {
                              selectedStudent = data;
                            });
                            getExams(data["student_id"]);
                          },
                          displayLabel: "student_name",
                          selectedKey: "student_id",
                          selectedId: selectedStudent["student_id"].toString(),
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
              SizedBox(height: 8),
              Divider(
                height: 2,
                color: Theme.of(context).primaryColor.withOpacity(.5),
                endIndent: 16,
                indent: 16,
              ),
              SizedBox(height: 8),
              /*Text(
                lang.text(
                    "Please choose the exam whose scores you want to know"),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),*/
              SizedBox(height: 8),
              userData["user_type"] == "P" ? getParentView() : getTeacherView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExamRow(Map exam) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            exam["name"] ?? lang.text("Undefined"),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Text(
            exam["state"].toString().toUpperCase() ?? lang.text("Undefined"),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                  text: lang.text("Start date:"),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: lang.text(" ${exam["start_date"]}"),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 4),
          Spacer(),
          RichText(
            text: TextSpan(
              style: TextStyle(fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                  text: lang.text("End date:"),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: lang.text(" ${exam["end_date"]}"),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TestResultPage(
            student: selectedStudent,
            exam: exam,
          );
        }));
      },
    );
  }

  Widget getParentView() {
    return exams.isNotEmpty
        ? ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildExamRow(exams[index]);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: exams.length)
        : selectedStudent["student_id"] != -1
        ? Container(
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Center(
            child: EmptyWidget(),
          ),
        ],
      ),
    )
        : Container();
  }

  Widget getTeacherView() {
    return students.isNotEmpty
        ? ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StudentExams(
                    student: students[index],
                  );
                },
              ),
            );
          },
          title: Text(students[index]["name"] ?? ""),
          subtitle: Text(
              "${lang.text(
                  "Student code")}: ${students[index]["student_code"] ?? ""}"),
        );
      },
      shrinkWrap: true,
      itemCount: students.length,
      primary: false,
    )
        : EmptyWidget();
  }
}
