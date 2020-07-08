import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/utils/lang.dart';

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
              alignment:
                  !lang.isRtl() ? Alignment.centerRight : Alignment.centerLeft,
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