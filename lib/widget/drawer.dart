import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/widget/circle_image.dart';

class DrawerWidget extends StatelessWidget {
  Map<String, dynamic> userData = {
    'username': 'User Name',
    'email': 'info@gmail.com'
  };

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
                    child: Image(
                      image: AssetImage('assets/images/profile.jpg'),
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                    borderColor: Theme
                        .of(context)
                        .primaryColor,
                    borderWidth: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData['username'],
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData['email'],
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
            color: Theme
                .of(context)
                .primaryColor,
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
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, RouteName.test);
          },
          title: Text(lang.text('Student profile')),
          leading: Icon(
            Icons.assignment,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, RouteName.tuitions);
          },
          title: Text(lang.text('Payment of fees')),
          leading: Icon(
            Icons.payment,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, RouteName.signup);
          },
          title: Text(lang.text('Register new student')),
          leading: Icon(
            Icons.person_add,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
        ListTile(
          onTap: () {},
          title: Text(lang.text('About us')),
          leading: Icon(
            Icons.people,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
      ],
    );
  }
}
