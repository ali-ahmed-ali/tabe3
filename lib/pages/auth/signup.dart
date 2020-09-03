import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_dropdown_list.dart';
import 'package:tabee/widget/custome_button.dart';
import 'package:tabee/widget/dialog_utils.dart';

import '../../utils/lang.dart';

class Signup extends StatefulWidget {
  final Map student;

  const Signup({Key key, this.student}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final Map<String, dynamic> _formData = {
    'name': null,
    'class': null,
    'age': null,
    'health_condition': null
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PrefManager _manager = new PrefManager();

  Repository _repository = new Repository();

  BuildContext context;

  List classes = [
    {"id": -1, "name": lang.text("-- Select class --")}
  ];

  Map<String, dynamic> selectedClass = {};

  Map<String, dynamic> userData = {};

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    _manager.get("customer", "{}").then((value) {
      Map<String, dynamic> data = json.decode(value);
      classes.addAll(data["available_class"]);
      userData = data;
      print('classes: $classes');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(lang.text('New Student')),
        centerTitle: true,
      ),
      //backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 20),
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: _buildForm(context),
            ),
          ],
        ),
      ),
    );
  }

  _buildForm(BuildContext context) {
    print('student: ${widget.student}');
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildUsernameTextField(),
          ),
          SizedBox(
            height: 8.0,
          ),
          widget.student != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.class_,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text("${widget.student["class_name"]}"),
                    ],
                  ),
                )
              : _buildClassTextField(),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildAgeTextField(),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildHealthTextField(),
          ),
          SizedBox(
            height: 8.0,
          ),
          CustomButton(
            label: lang.text('Register'),
            onPressed: widget.student != null ? null : () => register(),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget _buildClassTextField() {
    return CustomDropdownList(
      displayLabel: "name",
      selectedKey: "id",
      labels: classes,
      enabled: widget.student != null,
      selectedId: selectedClass["id"].toString(),
      prefix: Icon(Icons.class_),
      onChange: (data) {
        setState(() {
          selectedClass = data;
          _formData["class_id"] = data["id"];
        });
      },
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return lang.text('This is required');
        }
        return null;
      },
      keyboardType: TextInputType.text,
      enabled: widget.student == null,
      initialValue:
          "${widget.student != null ? widget.student["name"] ?? "" : ""}",
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_outline),
        labelText: lang.text('Full Name'),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData['name'] = value;
      },
    );
  }

  Widget _buildAgeTextField() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return lang.text('This is required');
        }
        return null;
      },
      keyboardType: TextInputType.number,
      initialValue:
          "${widget.student != null ? widget.student["age"] ?? "" : ""}",
      enabled: widget.student == null,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_today),
        labelText: lang.text('Age'),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData['age'] = value;
      },
    );
  }

  Widget _buildHealthTextField() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return lang.text('This is required');
        }
        return null;
      },
      initialValue:
          "${widget.student != null ? widget.student["health_condition"] ?? "" : ""}",
      enabled: widget.student == null,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.local_hospital),
        labelText: lang.text('Health Status'),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData['health_condition'] = value;
      },
    );
  }

  void register() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    showLoadingDialog(context);
    _formData["customer_id"] = userData["id"];
    Map response = await _repository.registerStudent(_formData);
    print('response: $response');
    Navigator.pop(context);
    if (response.containsKey("success") && response["success"]) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: Text(response["msg"])));
    }
  }
}
