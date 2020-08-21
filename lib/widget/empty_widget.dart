import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabee/utils/lang.dart';

class EmptyWidget extends StatelessWidget {
  final String svgPath;
  final String message;
  final String subMessage;
  final double size;
  const EmptyWidget(
      {Key key,
      this.message,
      this.size,
      this.subMessage,
      this.svgPath = "assets/icons/not-found.svg"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          svgPath,
          width: size ?? 24,
          color: Colors.grey,
        ),
        SizedBox(height: 8),
        Text(
          message ?? lang.text("No data found"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subMessage != null ? SizedBox(height: 8) : Container(),
        subMessage != null
            ? Text(
                subMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              )
            : Container(),
      ],
    );
  }
}
