import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomEditText extends StatefulWidget {
  final String countryCode;
  final String hint;
  final Color backgroundColor;
  final Color fontColor;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPhoneNumber;
  final bool isPassword;
  final bool enabled;
  final prefix;
  final int maxLines;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final Function(String) validator;
  final FocusNode focusNode;
  final List formatter;
  final String labelText;

  final TextDirection textDirection;

  const CustomEditText({
    Key key,
    this.hint,
    this.countryCode,
    this.backgroundColor = Colors.white,
    this.fontColor = Colors.black,
    this.controller,
    this.keyboardType,
    this.isPhoneNumber: false,
    this.isPassword: false,
    this.prefix,
    this.enabled: true,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.focusNode,
    this.formatter,
    this.validator,
    this.labelText,
    this.textDirection,
  }) : super(key: key);

  @override
  _CustomEditTextState createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                widget.prefix ?? Container(),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextFormField(
                    validator: widget.validator,
                    enabled: widget.enabled,
                    focusNode: widget.focusNode,
                    keyboardType: widget.keyboardType,
                    controller: widget.controller,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    maxLines: widget.maxLines,
                    textInputAction: widget.textInputAction,
                    textDirection:
                        widget.isPhoneNumber ? TextDirection.ltr : null,
                    obscureText: widget.isPassword ? hidePassword : false,
                    inputFormatters: widget.formatter ?? [],
                    style: TextStyle(fontSize: 14, color: widget.fontColor),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
//                  hintText: widget.hint,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: widget.fontColor)),
                      labelText: widget.labelText ?? widget.hint,
                      labelStyle:
                          TextStyle(fontSize: 14, color: widget.fontColor),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: widget.isPassword
                  ? IconButton(
                      icon: Icon(Icons.remove_red_eye, color: widget.fontColor),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
