import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/utils/push_notification.dart';
import 'package:tabee/widget/custom_edit_text.dart';
import 'package:tabee/widget/custome_button.dart';
import 'package:tabee/widget/dialog_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PrefManager _manager = new PrefManager();
  Repository _repository = new Repository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController mobileController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  FocusNode emailFocusNode = new FocusNode();

  FocusNode passwordFocusNode = new FocusNode();

  BuildContext context;

  String errorMessage;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      //backgroundColor: Color.fromRGBO(169, 221, 243, 1),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorDark,
              Colors.black38,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsetsDirectional.only(top: 30),
              child: Text(
                lang.text('Sign in'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 20),
              child: Image.asset(
                'assets/images/logowhite.png',
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: _buildForm(context),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  _buildForm(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
//          _buildEmailTextField(),
            errorMessage != null
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.red.withOpacity(.8),
                    ),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  )
                : Container(),
            CustomEditText(
              textDirection: TextDirection.ltr,
              prefix: Icon(Icons.phone, color: Colors.white),
              focusNode: emailFocusNode,
              controller: mobileController,
              labelText: lang.text("Mobile"),
              keyboardType: TextInputType.phone,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
              // validator: mobileValidator,
              textInputAction: TextInputAction.next,
              isPhoneNumber: true,
              countryCode: "249",
              fontColor: Colors.white,
              formatter: [new WhitelistingTextInputFormatter(RegExp("[0-9]"))],
            ),
//          _buildPasswordTextField(),
            CustomEditText(
              focusNode: passwordFocusNode,
              controller: passwordController,
//            validator: passwordValidator,
              labelText: lang.text("Password"),
              fontColor: Colors.white,
              textInputAction: TextInputAction.done,
              isPassword: true,
              prefix: Icon(Icons.lock_outline, color: Colors.white),
            ),
            SizedBox(height: 8),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.resetPwd);
              },
              child: Text(
                lang.text("Forget password? rest it"),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 24),
            CustomButton(
              label: Text(lang.text('Sign in')),
              onPressed: () {
                _submitButtonPressed();
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  String mobileValidator(String value) {
    RegExp regExp = new RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (value.isEmpty) {
      return lang.text('This is required');
    }
    if (!regExp.hasMatch(value)) {
      return lang.text("Invalid phone number");
    }
    /* else if (!value.startsWith("249")) {
//      return lang.text("Phone number must start with 249");
    }*/
    /*else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return lang.text('It should be an email');
    }*/
    return null;
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return lang.text('This is required');
    }
    /*else if (value.length < 6) {
//      return lang.text("Password must be greater then 6 letters and digits");
    }*/
    /*else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return lang.text('It should be an email');
    }*/
    return null;
  }

  void _submitButtonPressed() async {
    print('logging in');
    if (!_formKey.currentState.validate()) {
      return;
    }
    String mobile = mobileController.text.trim();
    String password = passwordController.text.trim();
    showLoadingDialog(context);
    //check user here
    print('Mobile is: $mobile, password is: $password');
    Map response = await _repository.loginCustomer(mobile, password);
    print('login response: $response');
    Navigator.pop(context);
    if (response.containsKey("success") && response["success"]) {
      Map<String, dynamic> user = {
        "id": response["customer"]["id"].toString(),
        "name": response["customer"]["name"] ?? "",
        "verify": response["customer"]["verify"] ?? "",
        "mobile": response["customer"]["mobile"] ?? "",
        "country_id": response["customer"]["country_id"] ?? false,
        "country_name": response["customer"]["country_name"] ?? false,
        "city_id": response["customer"]["city_id"] ?? false,
        "city_name": response["customer"]["city_name"] ?? false,
        "user_type": response["customer"]["user_type"] ?? "P",
        "available_class": response["available_class"] ?? [],
      };
      bool saved = await _manager.set("customer", json.encode(user));
      PushNotificationsManager(
          context: context,
          getToken: (token) async {
            Map tokenResponse = await _repository.updateToken(
                response["customer"]["id"].toString(), token);
            print('tokenResponse: $tokenResponse, token: $token');
            await _manager.set("firebase_notification_token", token);
          }).init();
      print('customer saved? $saved, customer: $user');
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.home, (route) => false);
    } else {
      setState(() {
        errorMessage = response["msg"];
      });
    }
  }
}
