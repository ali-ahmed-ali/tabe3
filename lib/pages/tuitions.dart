import 'package:flutter/material.dart';
import 'package:tabee/pages/confirm_webview.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custome_button.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class TuitionsPage extends StatefulWidget {
  final Map<String, dynamic> payslip;

  const TuitionsPage({Key key, this.payslip}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TuitionsState();
  }
}

class _TuitionsState extends State<TuitionsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  double _totalPrice;
  bool available = true;

  bool loading = false;

  List<int> selectedIds = [];

  final Repository _repository = new Repository();
  PrefManager _manager = new PrefManager();

  List payslipLines = [
    {'title': lang.text('Tuitions Fees'), 'value': true, 'amount': 5000},
    {'title': lang.text('Uniform'), 'value': true, 'amount': 500},
    {'title': lang.text('Books'), 'value': true, 'amount': 1000},
    {'title': lang.text('School Bus'), 'value': true, 'amount': 2000},
  ];

  @override
  void initState() {
    loadPayslipsLines();
    super.initState();
  }

  void loadPayslipsLines() async {
    setState(() {
      loading = true;
    });

    Map response = await _repository.getPayslipLines(widget.payslip["id"]);
    setState(() {
      loading = false;
    });
    print('Response: $response');
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        payslipLines = response["payable_lines"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(lang.text('Bill details')),
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: !available
            ? Container(
                child: Center(
                  child: EmptyWidget(
                    message: lang.text("Coming soon"),
                    size: 64,
                  ),
                ),
              )
            : loading
                ? LoadingWidget(
                    useLoader: true,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${lang.text("Bill date")}: ${widget.payslip["date"]}",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${lang.text('Bill No')}: ${widget.payslip["id"]}",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 24),
                      Divider(
                        height: 8,
                      ),
                      ListView.separated(
                        itemBuilder: (context, index) {
                          return _buildCheckBoxes(index);
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: payslipLines.length,
                        primary: true,
                        shrinkWrap: true,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    lang.text('Total'),
                                  )),
                                  Text(
                                    '\$${_getTotal().toString()}',
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 20),
                                  )
                                ],
                              ),
                              SizedBox(height: 16),
                              CustomButton(
                                label: lang.text("Confirm Payment"),
                                onPressed: confirmPayment,
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  _buildCheckBoxes(int index) {
    print('payslipLines ${payslipLines[index]}');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(lang.text(payslipLines[index]['name'])),
            ),
            SizedBox(width: 8),
            Text(
              payslipLines[index]['amount'].toString(),
              style: TextStyle(color: Colors.blueGrey, fontSize: 15),
            ),
            SizedBox(width: 8),
            !payslipLines[index]['is_paid']
                ? Checkbox(
                    value: payslipLines[index]['state'] == "draft",
                    onChanged: (value) {
                      setState(() {
                        payslipLines[index]['state'] =
                            value ? "draft" : "to-pay";
                        _getTotal();
                      });
                    })
                : Text(lang.text("Paid")),
          ],
        ),
      ),
    );
  }

  double _getTotal() {
    _totalPrice = 0;
    selectedIds.clear();
    for (var i = 0; i < payslipLines.length; i++) {
      if (payslipLines[i]['state'] == "draft") {
        selectedIds.add(payslipLines[i]['id']);
        _totalPrice += (payslipLines[i]['amount'] * 1.0);
      } else {
        selectedIds.remove(payslipLines[i]['id']);
      }
    }
    return _totalPrice;
  }

  void confirmPayment() async {
    print('ids: $selectedIds');
    showLoadingDialog(context);
    print('selected lines: $selectedIds');
    Map response = await _repository.confirmLinesPayment(selectedIds);
    Navigator.pop(context);
    print('response: $response');
    if (response.containsKey("success") && response["success"]) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPaymentWebView(
            payslipLine: response,
          ),
        ),
      );
      loadPayslipsLines();
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${response["message"] ?? response["msg"]}"),
      ));
    }
  }
}
