import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/pages/tuitions.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_dropdown_list.dart';
import 'package:tabee/widget/dialog_utils.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class Invoices extends StatefulWidget {
  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  Repository _repository = new Repository();
  PrefManager _manager = new PrefManager();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  List students = [
    {
      "student_id": -1,
      "student_name": lang.text("-- Select Student --"),
    }
  ];

  List invoices = [];

  Map userData = {};

  Map selectedStudent = {};

  bool loading = false;
  bool loadingInvoices = false;

  @override
  void initState() {
    selectedStudent = students[0];
    _manager.get("customer", "{}").then((value) {
      userData = json.decode(value);
      if (userData.containsKey("id") && userData["id"] != null) {
        getStudents();
      }
    });
    super.initState();
  }

  void getStudents() async {
    setState(() {
      loading = true;
    });
    Map response =
        await _repository.getStudents(int.parse(userData["id"].toString()));
    setState(() {
      loading = false;
    });
    print('students response: $response');
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        students.addAll(response["result"]["available_student"]);
        if (students.isNotEmpty) selectedStudent = students[0];
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          response["message"],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ));
    }
  }

  void getInvoices(int studentId) async {
    showLoadingDialog(context);
    Map response = await _repository.getPayslips(studentId);
    Navigator.pop(context);
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        invoices = response["payslips"];
      });
      print('invoices: $invoices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text("Invoices")),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8),
              SizedBox(height: 8),
              loading
                  ? Container(
                      height: 64,
                      child: LoadingWidget(useLoader: true, size: 24),
                    )
                  : CustomDropdownList(
                      labels: students,
                      onChange: (data) {
                        print('Data: $data');
                        setState(() {
                          selectedStudent = data;
                        });
                        getInvoices(data["student_id"]);
                      },
                      displayLabel: "student_name",
                      selectedKey: "student_id",
                      selectedId: selectedStudent["student_id"].toString(),
                    ),
              SizedBox(height: 8),
              Divider(
                height: 2,
                color: Theme.of(context).primaryColor.withOpacity(.5),
                endIndent: 16,
                indent: 16,
              ),
              SizedBox(height: 8),
              SizedBox(height: 8),
              invoices.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildInvoiceRow(invoices[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: invoices.length)
                  : selectedStudent["student_id"] != -1
                      ? Container(
                          padding: const EdgeInsets.only(top: 64),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Center(
                                child: EmptyWidget(),
                              ),
                            ],
                          ),
                        )
                      : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInvoiceRow(invoice) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            invoice["date"],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            "${lang.text("Total")}: ${invoice["total"]}",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.green,
            ),
          )
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${lang.text("Paid amount")}: ${invoice["paid_amount"]}",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TuitionsPage(payslip: invoice);
      })),
    );
  }
}
