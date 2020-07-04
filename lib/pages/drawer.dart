import 'package:flutter/material.dart';
import 'package:tabee/utils/lang.dart';

class DrawerWidget extends StatelessWidget {
  Map<String,dynamic> userData = {'username': 'User Name','email':'info@gmail.com'};
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
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    backgroundColor: Colors.white,
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
          onTap: (){},
          leading: Icon(
            Icons.equalizer,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(lang.text('Attendance')),
        ),
        ListTile(
          onTap: (){
            Navigator.pushNamed(context, 'news');
          },
          title: Text(lang.text('advertisements board')),
          leading: Icon(Icons.public,
            color: Theme.of(context).primaryColor,),
        ),
        ListTile(
          onTap: (){},
          title: Text(lang.text('Daily school schedule')),
          leading: Icon(Icons.schedule,
            color: Theme.of(context).primaryColor,),
        ),
        ListTile(
          onTap: (){
            Navigator.pushNamed(context, 'tests');
          },
          title: Text(lang.text('the exams')),
          leading: Icon(Icons.assignment,
            color: Theme.of(context).primaryColor,),
        ),
        ListTile(
          onTap: (){
            Navigator.pushNamed(context, 'tuitions');
          },
          title: Text(lang.text('Pay the fees')),
          leading: Icon(Icons.payment,
            color: Theme.of(context).primaryColor,),
        ),
        ListTile(
          onTap: (){
            Navigator.pushNamed(context,
                      'signup');
          },
          title: Text(lang.text('New student registration')),
          leading: Icon(Icons.person_add,
            color: Theme.of(context).primaryColor,),
        ),
        ListTile(
          onTap: (){},
          title: Text(lang.text('who are we')),
          leading: Icon(Icons.people,
            color: Theme.of(context).primaryColor,),
        ),
      ],
    );
  }
}
