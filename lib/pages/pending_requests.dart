import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/pages/auth/signup.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/utils/utils.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class PendingRequests extends StatefulWidget {
  @override
  _PendingRequestsState createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  final Repository _repository = new Repository();
  final PrefManager _manager = new PrefManager();

  List students = [];

  bool loading = false;

  Map userDate = {};

  @override
  void initState() {
    _manager.get("customer", "{}").then((value) {
      print('value is: $value');
      Map data = json.decode(value);
      userDate = data;
      print('userData should be: $userDate');
      loadRequests();
    });
    super.initState();
  }

  Future<void> loadRequests() async {
    setState(() {
      loading = true;
    });
    Map response = await _repository
        .getRegisterStudent(int.parse(userDate["id"].toString()));
    print('response: $response');
    setState(() {
      loading = false;
    });
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        students = response["result"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(lang.text("Registrations requests")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, RouteName.signup),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await loadRequests();
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? Container(
                  child: Center(
                    child: LoadingWidget(
                      useLoader: true,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: students.isEmpty
                      ? Center(
                          child: EmptyWidget(),
                        )
                      : Column(
                          children: <Widget>[
                            ListView.separated(
                              itemBuilder: (context, index) {
                                return buildStudentRow(students[index]);
                              },
                              separatorBuilder: (context, index) {
                                return Divider(color: Colors.black, height: 3);
                              },
                              itemCount: students.length,
                              shrinkWrap: true,
                              primary: false,
                            ),
                            SizedBox(height: 32)
                          ],
                        ),
                ),
        ),
      ),
    );
  }

  Widget buildStudentRow(Map student) {
    print('studnet: $student');
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(student["name"]),
          SizedBox(width: 8),
          Text(getStatus(student["status"] ?? ""))
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text("${student["class_name"]}"),
          Text("${lang.text("Age")}: ${student["age"]}")
        ],
      ),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Signup(student: student);
      })),
    );
  }
}
