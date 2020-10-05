import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_table.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class StudentTable extends StatefulWidget {
  final Map student;

  const StudentTable({Key key, this.student}) : super(key: key);

  @override
  _StudentTableState createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  final Repository _repository = new Repository();
  final PrefManager _manager = new PrefManager();

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

  @override
  void initState() {
    print('>>>>> ${widget.student}');
    getTimeTable(widget.student["id"]);
    super.initState();
  }

  void getTimeTable(int studentID) async {
    setState(() {
      loading = true;
    });
    setState(() {
      days = [];
      data = [];
      columns = [];
    });
    Map response = await _repository.getTimeTable(studentID);
    setState(() {
      loading = false;
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
                  // openChatWithTeacher(day.elementAt(k));
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student["name"] ?? ""),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: loading
            ? LoadingWidget(
                useLoader: true,
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
                : Container(
                    child: EmptyWidget(
                        /*subMessage: lang
                                  .text("Please select student to get table"),*/
                        ),
                  ),
      ),
    );
  }
}
