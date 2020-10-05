import 'package:flutter/material.dart';
import 'package:tabee/pages/student_result.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class StudentExams extends StatefulWidget {
  final Map student;

  const StudentExams({Key key, @required this.student}) : super(key: key);

  @override
  _StudentExamsState createState() => _StudentExamsState();
}

class _StudentExamsState extends State<StudentExams> {
  Repository _repository = new Repository();
  PrefManager _manager = new PrefManager();

  List exams = [];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool loading = false;

  @override
  void initState() {
    getExams(widget.student["id"]);
    super.initState();
  }

  void getExams(int studentID) async {
    exams.clear();
    setState(() {
      loading = true;
    });
    Map response = await _repository.getExams(studentID);
    setState(() {
      loading = false;
    });
    print('Exam response: $response');
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        exams = response["exams"] as List;
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(response["message"] ?? ""),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.student["name"] ?? ""),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: loading
            ? Center(
                child: LoadingWidget(useLoader: true),
              )
            : exams.isEmpty
                ? Center(child: EmptyWidget())
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return buildExamRow(exams[index]);
                    },
                    shrinkWrap: true,
                    primary: false,
                    itemCount: exams.length,
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
            student: widget.student,
            exam: exam,
          );
        }));
      },
    );
  }
}
