import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final label;
  final VoidCallback onPressed;
  final Color color;

  const CustomButton(
      {Key key, @required this.label, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8.0),
      child: RaisedButton(
        color: color ?? Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: label is String ? Text(label) : label,
        ),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textColor: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
