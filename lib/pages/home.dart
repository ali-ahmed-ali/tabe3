import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/pages/drawer.dart';
import 'package:tabee/utils/lang.dart';

class HomePage extends StatelessWidget {
  double _phoneHeight;
  final List<Map<String, dynamic>> _menuItems = [
    {'image': 'assets/images/board.png', 'title': lang.text('Daily school schedule'),'routing':'schedule'},
    {'image': 'assets/images/percent.png', 'title': lang.text('The Exams'),'routing':'tests'},
    {'image': 'assets/images/cash.png', 'title': lang.text('Pay the fees'),'routing':'tuitions'},
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
      ),
      body: Container(
        child: ListView.builder(
            itemCount: _menuItems.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildMenuItemView(context, _menuItems[index]['image'],
                  _menuItems[index]['title'],_menuItems[index]['routing']);
            }),
      ),
    );
  }

  _buildMenuItemView(BuildContext context, String image, String title,String pageRoute) {
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
          SizedBox(height: 40,),
          Text(
            lang.text(title),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 40,),
          GestureDetector(
            onTap: ()
            {
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
