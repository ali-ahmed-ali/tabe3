import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/circle_image.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  PrefManager _manager = new PrefManager();

  Map<dynamic, dynamic> userData = {};

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  void loadUserData() async {
    String userDataString = await _manager.get("customer", "{}");
    print('userDataString: $userDataString');
    setState(() {
      userData = json.decode(userDataString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: DrawerHeader(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleImage(
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://cdn.pixabay.com/photo/2016/04/26/07/20/woman-1353803__340.png",
                      width: 60,
                      height: 60,
                      placeholder: (error, url) => Image(
                        image: AssetImage('assets/images/profile.jpg'),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                    borderColor: Theme.of(context).primaryColor,
                    borderWidth: 1,
                  ),
                  SizedBox(height: 8),
                  Text(
                    userData['name'] ?? "Username",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 4),
                  Text(
                    userData['mobile'] ?? "-",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteName.attend);
          },
          leading: Icon(
            Icons.equalizer,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(lang.text('Attendance')),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteName.news);
          },
          title: Text(lang.text('Advertisements board')),
          leading: Icon(
            Icons.public,
            color: Theme.of(context).primaryColor,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteName.schedule);
          },
          title: Text(lang.text('Daily school schedule')),
          leading: Icon(
            Icons.schedule,
            color: Theme.of(context).primaryColor,
          ),
        ),
//        ListTile(
//          onTap: () {
//            Navigator.pushNamed(context, RouteName.exams);
//          },
//          title: Text(lang.text('Student profile')),
//          leading: Icon(
//            Icons.assignment,
//            color: Theme.of(context).primaryColor,
//          ),
//        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, RouteName.tuitions);
          },
          title: Text(lang.text('Pay the fees')),
          leading: Icon(
            Icons.payment,
            color: Theme.of(context).primaryColor,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteName.registerRequest);
          },
          title: Text(lang.text('Register new student')),
          leading: Icon(
            Icons.person_add,
            color: Theme.of(context).primaryColor,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, RouteName.aboutUs);
          },
          title: Text(lang.text('About us')),
          leading: Icon(
            Icons.people,
            color: Theme.of(context).primaryColor,
          ),
        ),
        ListTile(
          onTap: () async {
            await _manager.remove("customer");
            await _manager.remove("firebase_notification_token");
            Navigator.pushNamedAndRemoveUntil(context, RouteName.splash,
                ModalRoute.withName(RouteName.splash));
          },
          title: Text(lang.text('Logout')),
          leading: Icon(
            Icons.exit_to_app,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
