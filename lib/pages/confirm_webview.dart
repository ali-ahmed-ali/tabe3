import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:tabee/utils/lang.dart';

class ConfirmPaymentWebView extends StatefulWidget {
  final Map payslipLine;

  const ConfirmPaymentWebView({Key key, @required this.payslipLine})
      : super(key: key);

  @override
  _ConfirmPaymentWebViewState createState() => _ConfirmPaymentWebViewState();
}

class _ConfirmPaymentWebViewState extends State<ConfirmPaymentWebView> {
  @override
  Widget build(BuildContext context) {
    print('${widget.payslipLine}');
    return WebviewScaffold(
      url: widget.payslipLine["url"],
      appBar: AppBar(
        title: Text("${lang.text("Bill No")}: ${widget.payslipLine["id"]}"),
      ),
      clearCache: true,
      clearCookies: true,
    );
  }
}
