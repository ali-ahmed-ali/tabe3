import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/dashboard_card.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/drawer.dart';
import 'package:tabee/widget/loading_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _phoneHeight;
  Repository _repository = new Repository();
  PrefManager _manager = new PrefManager();
  bool loading = false;

  List<Map<String, dynamic>> _menuItems = [];

  Map userData;

  @override
  void initState() {
    _manager.get("customer", "{}").then((value) {
      userData = json.decode(value);
      _menuItems = [
        {
          'image': 'assets/icons/appointment.svg',
          'title': lang.text('Daily school schedule'),
          'routing': RouteName.schedule,
        },
        {
          'image': 'assets/icons/score.svg',
          'title': lang.text('The Exams'),
          'routing': RouteName.exams,
        },
        {
          'image': 'assets/icons/attend.svg',
          'title': lang.text('Attendance'),
          'routing': RouteName.attend,
        },
        {
          'image': 'assets/icons/news2.svg',
          'title': lang.text('Advertisements board'),
          'routing': RouteName.news,
        },
      ];

      if (userData["user_type"] == "P") {
        _menuItems.add(
          {
            'image': 'assets/icons/cash-payment.svg',
            'title': lang.text('Pay the fees'),
            'routing': RouteName.invoices,
            'show': userData["user_type"].toString() == "P"
          },
        );
      }
    });
    loadStudents();
    super.initState();
  }

  void loadStudents() async {
    setState(() {
      loading = true;
    });
    Map user = json.decode(await _manager.get("customer", "{}"));
    Map response = await _repository.getStudents(int.parse("${user["id"]}"));
    setState(() {
      loading = false;
    });

    if (response.containsKey("success") && response["success"]) {
      bool saved = await _manager.set(
          "students", json.encode(response["available_student"]));
      print('Saved students: ${await _manager.get("students", "[]")}');
    }
  }

  @override
  Widget build(BuildContext context) {
    _phoneHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      drawer: Drawer(
        child: DrawerWidget(),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(!loading ? userData["school_name"] : lang.text('Home')),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.language,
              color: Colors.white,
            ),
            onPressed: () async {
              var selected = await showPreferredLang(
                  context, false, lang.text("Select language"));
              var currentLang = lang.currentLanguage;
              print('Selected: $selected');
              await lang.setNewLanguage(selected, true);
              setState(() {});
              AppBuilder.of(context).rebuild();
              if (selected != currentLang) {
                Navigator.pushNamedAndRemoveUntil(context, RouteName.splash,
                    ModalRoute.withName(RouteName.splash));
              }
            },
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: loading
            ? Center(
                child: LoadingWidget(
                useLoader: true,
              ))
            : StaggeredGridView.countBuilder(
                itemCount: _menuItems.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map item = _menuItems[index];
                  return DashboardCard(
                    icon: SvgPicture.asset(
                      item["image"],
                      color: Colors.white,
                      width: 64,
                    ),
                    title: item["title"],
                    onPressed: () {
                      print('Route to: ${item["routing"]}');
                      Navigator.pushNamed(context, item["routing"]);
                    },
                  );
                },
                crossAxisCount: 2,
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count(1, index.isEven ? 2 : 1),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.conversations);
        },
        child: SvgPicture.asset(
          "assets/icons/chat.svg",
          color: Colors.white,
          width: 32,
        ),
      ),
    );
  }

  Widget _buildMenuItemView(
      BuildContext context, String image, String title, String pageRoute) {
    return Container(
      //color: Theme.of(context).primaryColor.withOpacity(.5),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      height: _phoneHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(image),
          SizedBox(
            height: 40,
          ),
          Text(
            lang.text(title),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, pageRoute);
            },
            child: Text(
              lang.text("More"),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          //SizedBox(height: 40,),
        ],
      ),
    );
  }
}
