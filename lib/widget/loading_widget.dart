import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tabee/utils/lang.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  final bool useLoader;
  final double size;
  const LoadingWidget(
      {Key key, this.message, this.useLoader = false, this.size = 42.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useLoader
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SpinKitThreeBounce(
                size: size,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 16),
              Text(message ?? lang.text("loading"))
            ],
          )
        : Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text(message ?? lang.text("loading"))),
            ],
          );
  }
}
