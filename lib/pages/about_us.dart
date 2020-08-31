import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabee/utils/lang.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text("About us")),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                width: 200,
                height: 200,
              ),
              SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey,
                width: double.infinity,
                child: Text(
                  lang.text("About us"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
//            SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    /*Text(
                  lang.text("about_us_long"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                )*/
                    Html(
                  data: lang.text("about_us_long"),
                  style: {
                    "b": Style(
                      color: Theme.of(context).primaryColorDark,
                    )
                  },
                ),
              ),
              SizedBox(height: 8),
              Divider(),
              Container(
                color: Colors.grey,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(
                  lang.text("Contact us"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildSocialRow(
                  Icon(
                    Icons.language,
                    size: 32,
                    color: Theme.of(context).primaryColorDark,
                  )
                  /* SvgPicture.asset(
                    "assets/icons/website.svg",
                    width: 32,
                    color: Theme.of(context).primaryColorDark,
                  )*/
                  ,
                  lang.text("Visit our website"),
                  "http://Www.moggal.com",
                  Theme.of(context).primaryColorDark),
              SizedBox(height: 8),
              _buildSocialRow(
                  SvgPicture.asset(
                    "assets/icons/phone.svg",
                    width: 32,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  lang.text("Call us"),
                  "tel:249110160580",
                  Theme.of(context).primaryColorDark),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialRow(Widget icon, String name, String url,
      [Color textColor]) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      elevation: 8.0,
      child: InkWell(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw "Cannot open URL";
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            children: <Widget>[
              icon,
              SizedBox(width: 16.0),
              Text(
                name,
                style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
