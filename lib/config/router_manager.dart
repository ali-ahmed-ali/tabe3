import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/anims/page_route_anim.dart';
import 'package:tabee/pages/auth/reset_password.dart';
import 'package:tabee/pages/auth/update_password.dart';
import 'package:tabee/pages/auth/verify.dart';
import 'package:tabee/pages/conversations_page.dart';
import 'package:tabee/pages/home.dart';
import 'package:tabee/pages/language_selector.dart';
import 'package:tabee/pages/news.dart';
import 'package:tabee/pages/splash.dart';
import 'package:tabee/pages/start_page.dart';
import 'package:tabee/pages/start_tab_preview.dart';
import 'package:tabee/pages/test_result.dart';
import 'package:tabee/pages/time_table_page.dart';
import 'package:tabee/pages/tuitions.dart';

import 'file:///D:/Projects/Android/Tabee3/Tabe3/lib/pages/auth/login.dart';
import 'file:///D:/Projects/Android/Tabee3/Tabe3/lib/pages/auth/signup.dart';

class RouteName {
  // TODO: When adding new page specify name for it
  static const String splash = '/';
  static const String startPage = '/start';
  static const String sliderPage = '/slidaerPage';
  static const String languageSelector = 'languageSelector';
  static const String home = 'home';
  static const String login = 'login';
  static const String resetPwd = 'resetPwd';
  static const String verify = 'verify';
  static const String startTapPreview = 'startTapPreview';
  static const String signup = 'signup';
  static const String test = 'tests';
  static const String tuitions = 'tuitions';
  static const String news = 'news';
  static const String schedule = 'schedule';
  static const String attend = 'attend';
  static const String conversations = 'conversations';

  static const String updatePassword = "updatePassword";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // TODO: After specify name, use (case) to new name and return class wrapped with animation type
    // TODO: You can find animations in /anims/page_route_anim.dart
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.startPage:
        return FadeRouteBuilder(StartPage());
      case RouteName.sliderPage:
        return FadeRouteBuilder(StartTabPreview());
      case RouteName.languageSelector:
        return NoAnimRouteBuilder(LanguageSelector());
      case RouteName.home:
        return SlideTopRouteBuilder(HomePage());
      case RouteName.login:
        return SlideTopRouteBuilder(LoginPage());
      case RouteName.resetPwd:
        return SlideTopRouteBuilder(ResetPassword());
      case RouteName.verify:
        return SlideTopRouteBuilder(VerifyScreen());
      case RouteName.updatePassword:
        return SlideTopRouteBuilder(UpdatePassword());
      case RouteName.startTapPreview:
        return SlideTopRouteBuilder(StartTabPreview());
      case RouteName.signup:
        return SlideTopRouteBuilder(Signup());
      case RouteName.schedule:
        return SlideTopRouteBuilder(TimeTablePage());
//      case RouteName.attend:
//        return FadeRouteBuilder();
      case RouteName.test:
        return SlideTopRouteBuilder(TestResultPage());
      case RouteName.tuitions:
        return SlideTopRouteBuilder(TuitionsPage());
      case RouteName.news:
        return SlideTopRouteBuilder(NewsPage());
      case RouteName.conversations:
        return SlideTopRouteBuilder(ConversationsPage());

      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('${settings.name}'),
                  ),
                ));
    }
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
