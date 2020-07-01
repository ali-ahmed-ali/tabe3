import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/anims/page_route_anim.dart';
import 'package:tabee/pages/home.dart';
import 'package:tabee/pages/language_selector.dart';
import 'package:tabee/pages/splash.dart';
import 'package:tabee/pages/start_page.dart';

class RouteName {
  // TODO: When adding new page specify name for it
  static const String splash = '/';
  static const String startPage = '/start';
  static const String languageSelector = 'languageSelector';
  static const String home = 'home';
  static const String login = 'login';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // TODO: After specify name, use (case) to new name and return class wrapped with animation type
    // TODO: You can find animations in /anims/page_route_anim.dart
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.startPage:
        return NoAnimRouteBuilder(StartPage());
      case RouteName.languageSelector:
        return NoAnimRouteBuilder(LanguageSelector());
      case RouteName.home:
        return SlideTopRouteBuilder(HomePage());

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
