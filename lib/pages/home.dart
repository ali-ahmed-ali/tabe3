import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/drawer.dart';

class HomePage extends StatelessWidget {
  double _phoneHeight;
  final List<Map<String, dynamic>> _menuItems = [
    {
      'image': 'assets/images/board.png',
      'title': lang.text('Daily school schedule'),
      'routing': RouteName.schedule,
    },
    {
      'image': 'assets/images/percent.png',
      'title': lang.text('The Exams'),
      'routing': RouteName.test,
    },
    {
      'image': 'assets/images/cash.png',
      'title': lang.text('Pay the fees'),
      'routing': RouteName.tuitions,
    },
  ];

  @override
  Widget build(BuildContext context) {
    _phoneHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      drawer: Drawer(
        child: DrawerWidget(),
      ),
      appBar: AppBar(
        title: Text(lang.text('Home')),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.translate,
              color: Colors.white,
            ),
            onPressed: () async {
              var selected = await showPreferredLang(
                  context, false, lang.text("Select language"));
              print('Selected: $selected');
            },
          )
        ],
      ),
      body: Container(
        child: CarouselSlider(
          items: _menuItems.map((e) {
            return _buildMenuItemView(
                context, e['image'], e['title'], e['routing']);
          }).toList(),
          options: CarouselOptions(
            height: MediaQuery
                .of(context)
                .size
                .height,
            scrollDirection: Axis.vertical,
            enableInfiniteScroll: false,
            autoPlay: false,
            enlargeCenterPage: true,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemView(BuildContext context, String image, String title,
      String pageRoute) {
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
              style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor),
            ),
          ),
          //SizedBox(height: 40,),
        ],
      ),
    );
  }
}
