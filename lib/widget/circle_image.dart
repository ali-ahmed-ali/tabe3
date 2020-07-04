import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Color borderColor;

  const CircleImage({
    Key key,
    this.child,
    this.borderColor = Colors.grey,
    this.borderWidth = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: this.borderWidth,
          color: this.borderColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(100.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: child,
        ),
      ),
    );
  }
}
