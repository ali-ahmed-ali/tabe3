import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custome_button.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    double _buttonSize = MediaQuery.of(context).size.width;
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      elevation: 2,
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            Text(
                              lang.text("Choose the language you prefer"),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            ListView.separated(
                                itemBuilder: (context, index) {
                                  Locale item =
                                      lang.supportedLocales().toList()[index];
                                  bool selected =
                                      lang.currentLanguage == item.languageCode;
                                  return Container(
                                    child: ListTile(
                                      onTap: () {
                                        _handleLanguageChange(
                                            item.languageCode);
                                      },
                                      leading: Icon(
                                        Icons.done,
                                        color: selected
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                      ),
                                      title: Text(
                                          lang.text(
                                              "i18n_${item.languageCode}"),
                                          style: TextStyle(
                                            fontWeight: selected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: selected
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,
                                          )),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    height: 1,
                                    color: Colors.grey,
                                  );
                                },
                                shrinkWrap: true,
                                primary: true,
                                itemCount:
                                    lang.supportedLocales().toList().length),
                            SizedBox(height: 16.0),
                            CustomButton(
                              label: lang.text("Start"),
                              onPressed: () async {
                                await PrefManager().set("firstLaunch", false);
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteName.sliderPage,
                                    ModalRoute.withName(RouteName.splash));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLanguageChange(String value) async {
    await lang.setNewLanguage(value, true);
    AppBuilder.of(context).rebuild();
  }
}
