import 'package:flutter/material.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/wavy_header.dart';

Future<bool> showUpdateDialog(BuildContext context,
    {String body, bool isRequired = false}) async {
  // flutter defined function
  var status = await showDialog(
    context: context,
    barrierDismissible: !isRequired,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              WavyHeader(
                child: Container(
                  child: Text(
                    lang.text("App Update"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: body != null
                    ? Text(
                        body,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    : Container(),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                      child: Text(lang.text("update")),
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  RaisedButton(
                      child: Text(lang.text("Cancel")),
                      textColor: Colors.white,
                      onPressed: isRequired
                          ? null
                          : () {
                              Navigator.of(context).pop(false);
                            },
                      color: Colors.red[300],
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ],
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.only(top: 0, bottom: 8, left: 0, right: 0),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0),
        ),
      );
    },
  );
  return status ?? false;
}

Future<bool> showCustomDialog(BuildContext context,
    {@required Widget title,
    Widget subtitle,
    @required Widget positiveLabel,
    Widget negativeLabel,
    Color negativeColor,
    @required Color positiveColor,
    bool isDismissible = true}) async {
  // flutter defined function
  var status = await showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                title,
                SizedBox(
                  height: 16,
                ),
                subtitle ?? Container(),
                subtitle == null
                    ? Container
                    : SizedBox(
                        height: 16,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        child: positiveLabel,
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                        color: positiveColor,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                    SizedBox(width: 16),
                    negativeLabel != null
                        ? RaisedButton(
                            child: negativeLabel,
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            color: negativeColor,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)))
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
          contentPadding:
              EdgeInsets.only(top: 32, bottom: 8, left: 16, right: 16),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(16.0)));
    },
  );
  return status ?? false;
}

Future<bool> showNoInternetDialog(BuildContext context) async {
  bool openSettings = await showCustomDialog(
    context,
    title: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image(
          image: AssetImage("assets/img/img_no_internet.png"),
          width: 128,
          height: 128,
        ),
        Text(
          lang.text("No Internet"),
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    subtitle: Text(
      lang.text("Ooops, Please check your internet connection."),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    ),
    negativeLabel: null,
    positiveLabel: Text(
      lang.text("OK"),
      style: TextStyle(color: Colors.white),
    ),
    negativeColor: Color(0xFFe6e6e6),
    positiveColor: Theme.of(context).primaryColor,
  );
//  if (openSettings) {
//    AppSettings.openWIFISettings();
//  }
  return openSettings;
}

Future<String> showLanguageDialog(BuildContext context) async {
  String selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Text(
                    lang.text(
                        "language_${lang.supportedLocales().elementAt(index)}"),
                  ),
                );
              },
              itemCount: lang.supportedLocales().length,
              primary: false,
              shrinkWrap: true,
            ),
          ),
        );
      });

  return selected ?? null;
}

Future<String> showPreferredLang(BuildContext context,
    [bool isRequired = false, title = "", String hint]) async {
  String currentLang = await PrefManager().get("lang_key", "ar");
  String pref = await showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {},
      transitionDuration: Duration(milliseconds: 700),
      barrierColor: Colors.blue.withOpacity(0.2),
      barrierLabel: '',
      barrierDismissible: !isRequired,
      transitionBuilder: (context, anim1, anim2, childe) {
        final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
        return Transform(
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0))),
                      child: Center(
                        child: Text(
                          title ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          hint != null
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("*",
                                        style:
                                            TextStyle(color: Colors.redAccent)),
                                    SizedBox(width: 4.0),
                                    Expanded(
                                      child: Text(
                                        hint,
                                        softWrap: true,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(height: 16.0),
                          ListTile(
                            title: Text(lang.text("English")),
                            onTap: () => Navigator.pop(context, 'en'),
                          ),
                          ListTile(
                            title: Text(lang.text("العربية")),
                            onTap: () => Navigator.pop(context, 'ar'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              contentPadding:
                  EdgeInsets.only(top: 0, bottom: 8, left: 0, right: 0),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0),
              ),
            ),
          ),
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        );
      });
  return pref ?? currentLang;
}
