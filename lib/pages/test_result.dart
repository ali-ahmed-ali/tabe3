import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart' as ratingStars;
import 'package:tabee/utils/lang.dart';

class TestResultPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResultPageState();
  }
}

class _ResultPageState extends State<TestResultPage>
    with SingleTickerProviderStateMixin {
  String rank = 'First';
  double total = 0.0;
  TabController _controller;
  List<Map<String, dynamic>> _subjectsGrade = [
    {'sub_name': 'Arabic', 'grade': 100},
    {'sub_name': 'English', 'grade': 60},
    {'sub_name': 'Math', 'grade': 85},
    {'sub_name': 'Science', 'grade': 90},
    {'sub_name': 'Geographic', 'grade': 100},
    {'sub_name': 'Quran', 'grade': 100},
  ];
  String _comment =
      'ggh jgjh gjh gjkh hj hj g jhg hghjghgjhgh gh hjg hjg hjghjghg jhg hg jhg';

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Studnet Name'),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/profile.jpg',
                height: 150,
                width: 150,
              ),
            ),
            Text(
              lang.text('First Term Result'),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
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
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Divider(),
            ),
            _buildTabs(),
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
            Tab(
              text: lang.text('Comment'),
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 200,
          child: TabBarView(controller: _controller, children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: _getTableRows(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Center(
                        child: Text(lang.text('Grade')),
                      )),
                      Expanded(
                          child: Center(
                        child: Text(lang.text(rank)),
                      )),
                    ],
                  ),
                )
              ],
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 200,
                child: Text(_comment)),
          ]),
        )
      ],
    );
  }

  _getTableRows() {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Colors.grey),
        children: _subjectsGrade.map((item) {
          return TableRow(
              decoration: BoxDecoration(
                color: _getColorsFromPercent(
                    double.parse(item['grade'].toString())),
              ),
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(item['sub_name']),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(item['grade'].toString()),
                ),
              ]);
        }).toList());
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
