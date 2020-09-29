import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_dropdown_list.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
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
  List exams = [];
  List news = [];
  Map selectedStudent = {};

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

  void getNews(int studentID) async {
    showLoadingDialog(context);
    Map response = await _repository.getNews(studentID);
    print('News response: $response');
    Navigator.pop(context);
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        news = response["result"];
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(response["msg"]),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(lang.text('Advertisements board')),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            loading
                ? Container(
                    height: 64,
                    child: LoadingWidget(useLoader: true, size: 24),
                  )
                : CustomDropdownList(
                    labels: students,
                    selectedId: selectedStudent["student_id"].toString(),
                    onChange: (data) {
                      print('Data: $data');
                      setState(() {
                        selectedStudent = data;
                      });
                      getNews(data["student_id"]);
                    },
                    displayLabel: "student_name",
                    selectedKey: "student_id",
                    label: lang.text("Select student"),
                  ),
            SizedBox(height: 8),
            Divider(
              height: 2,
              color: Theme.of(context).primaryColor.withOpacity(.5),
              endIndent: 16,
              indent: 16,
            ),
            SizedBox(height: 8),
            news.isNotEmpty
                ? ListView.builder(
                    itemCount: news.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return buildNewsRow(news[index]);
                    })
                : selectedStudent["student_id"] != -1
                    ? EmptyWidget()
                    : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildNewsRow(Map<String, dynamic> map) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.public),
            title: Text(
              map['title'],
            ),
            trailing: Text(
              map['date'],
            ),
            subtitle: Text(
              map['body'],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          /*Text(news[index]['body']),
                        SizedBox(
                          height: 20,
                        ),*/
          Divider(),
        ],
      ),
    );
  }
}
