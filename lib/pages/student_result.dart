import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart' as ratingStars;
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/circle_image.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class TestResultPage extends StatefulWidget {
  final Map student;
  final Map exam;

  const TestResultPage({Key key, this.student, this.exam}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ResultPageState();
  }
}

class _ResultPageState extends State<TestResultPage>
    with SingleTickerProviderStateMixin {
  final Repository _repository = new Repository();
  final PrefManager _manager = new PrefManager();
  String rank = 'First';
  double total = 0.0;
  bool loading = false;
  TabController _controller;
  List _subjectsGrade = [
    {
      "subject": lang.text("Subject"),
      "obtained_marks": lang.text("Obtained Mark"),
      "minimum_marks": lang.text("Minimum Mark"),
      "maximum_marks": lang.text("Maximum Mark"),
    }
  ];
  String _comment =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip';

  @override
  void initState() {
    _controller = TabController(length: 1, vsync: this);
    getResults();
    super.initState();
  }

  void getResults() async {
    setState(() {
      loading = true;
    });
    Map response = await _repository.getResult(
        widget.exam["id"], widget.student["student_id"]);
    print('Result response: $response');
    setState(() {
      loading = false;
      if (response.containsKey("success") && response["success"]) {
        setState(() {
          _subjectsGrade.addAll(response["exam_ids"]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('>>>>>>>>>> ${_subjectsGrade}');
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${widget.student["student_name"] ?? lang.text("Undefined")}"),
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
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.favorite_border),
//            onPressed: () {},
//          )
//        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            SizedBox(height: 16.0),
            CircleImage(
              child: Container(
                width: 80,
                height: 80,
                child: Center(
                  child: Text(
                    (widget.student["student_name"] ?? lang.text("Undefined"))
                        .toString()
                        .characters
                        .elementAt(0),
                    softWrap: true,
                    locale: lang.locale,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              borderColor: Theme
                  .of(context)
                  .primaryColor,
              borderWidth: 1,
            ),
            SizedBox(height: 8),
            Text(
              widget.student["student_class"] ?? lang.text("Undefined"),
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8,
            ),
            /*Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildRatingStars(_getRating(_getTotalResult())),
                  SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      (_getTotalResult().toStringAsFixed(1).toString()) + '%',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )
                ],
              ),
            ),*/
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Divider(),
            ),
            loading
                ? Container(
              child: Center(
                child: LoadingWidget(
                  useLoader: true,
                  size: 32,
                ),
              ),
            )
                : _buildTabs(),
          ],
        ),
      ),
    );
  }

  _buildRatingStars(double ratingValue) {
    return ratingStars.SmoothStarRating(
      rating: ratingValue,
      isReadOnly: true,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      defaultIconData: Icons.star_border,
      starCount: 5,
      allowHalfRating: true,
      spacing: 2,
    );
  }

  _buildTabs() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: new TabBar(controller: _controller, tabs: [
            Tab(
              text: lang.text('Degrees'),
            ),
          ]),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 200,
          child: TabBarView(controller: _controller, children: <Widget>[
            _subjectsGrade.isNotEmpty
                ? ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            _getTableRows(),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: EmptyWidget(),
                  ),
          ]),
        )
      ],
    );
  }

  _getTableRows() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Theme
            .of(context)
            .primaryColor
            .withOpacity(.5),
      ),
      children: getTableData(),
    );
  }

  List<TableRow> getTableData() {
//    _subjectsGrade.insert(0, {
//      "obtained_marks": double.parse("0.0"),
//      "subject": "Subject name",
//    });
    return _subjectsGrade.map((item) {
      print('item >>>>>> $item');
      return TableRow(
          decoration: BoxDecoration(
            // color: _getColorsFromPercent(
            //     double.parse("${item['obtained_marks'] ?? "0.0"}")),
          ),
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(item['subject'] ?? lang.text("Undefined")),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(item['obtained_marks'].toString()),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(item['minimum_marks'].toString()),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(item['maximum_marks'].toString()),
            ),
          ]);
    }).toList();
  }

  Color _getColorsFromPercent(double percent) {
    double k1 = 256 - (percent - 50) * 5.12;
    int red = percent < 50 ? 255 : k1.round();
    double k2 = (percent) * 5.12;
    int green = percent > 50 ? 255 : k2.round();
    return Color.fromARGB(255, red, green, 0).withOpacity(.5);
  }

  double _getRating(double p) {
    if (p > 90) {
      return 5.0;
    } else if (p > 80 && p < 90) {
      return 4.5;
    } else if (p > 70 && p < 80) {
      return 4.0;
    } else if (p > 60 && p < 70) {
      return 3.5;
    } else if (p > 50 && p < 60) {
      return 3.0;
    } else if (p > 40 && p < 50) {
      return 2.5;
    } else if (p > 30 && p < 40) {
      return 2.0;
    } else if (p > 20 && p < 30) {
      return 1.5;
    } else if (p > 10 && p < 20) {
      return 1.0;
    } else if (p > 0 && p < 10) {
      return 0.5;
    } else if (p == 0) {
      return 0.0;
    }
  }

  double _getTotalResult() {
    total = 0.0;
    for (var i = 0; i < _subjectsGrade.length; i++) {
      total += double.parse(_subjectsGrade[i]['grade'].toString());
    }
    return (total / (_subjectsGrade.length * 100)) * 100;
  }
}
