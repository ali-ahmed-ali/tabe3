import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedEditText extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final List formatters;
  final TextInputType keyboardType;
  final bool enabled;
  final TextInputAction textInputAction;
  final Function(String value) validator;
  final Function(String value) onFieldSubmitted;
  final Widget attachFile;

  const RoundedEditText(
      {Key key,
      this.controller,
      this.hint,
      this.formatters,
      this.keyboardType,
      this.enabled,
      this.textInputAction,
      this.validator,
      this.onFieldSubmitted,
      this.attachFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 8.0),
//            Icon(Icons.insert_emoticon,
//                size: 30.0, color: Theme.of(context).hintColor),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                ),
              ),
              attachFile ?? SizedBox(),
//              SizedBox(width: 8.0),
//              Icon(Icons.camera_alt,
//                  size: 30.0, color: Theme.of(context).hintColor),
              SizedBox(width: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
