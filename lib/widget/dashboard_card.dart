import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final icon;
  final title;
  final subtitle;
  final VoidCallback onPressed;

  const DashboardCard(
      {Key key, this.icon, this.title, this.onPressed, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(.9),
                Theme.of(context).primaryColorDark,
//                Colors.black.withOpacity(.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0)),
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          splashColor: Colors.white,
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: icon,
              ),
              SizedBox(height: 16.0),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: title is String
                        ? Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                          )
                        : title,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
* 
* Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: icon,
            ),
            SizedBox(width: 8.0),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  title is String
                      ? Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                          softWrap: true,
//                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        )
                      : title,
                  SizedBox(
                    height: 8,
                  ),
//                  subtitle is String && subtitle != null
//                      ? Text(
//                          subtitle,
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 14.0,
//                          ),
//                          softWrap: true,
//                          overflow: TextOverflow.ellipsis,
//                          textAlign: TextAlign.start,
//                        )
//                      : subtitle,
                ],
              ),
            )
          ],
        )*/
