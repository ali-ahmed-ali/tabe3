import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/custom_edit_text.dart';
import 'package:tabee/widget/custome_button.dart';
import 'package:tabee/widget/dialog_utils.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  PrefManager _manager = new PrefManager();
  Repository _repository = new Repository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController mobileController = new TextEditingController();

  String errorMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorDark,
              Colors.black38,
              Theme.of(context).primaryColor.withOpacity(.9),
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
                lang.text('Reset password'),
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

  Widget _buildForm(BuildContext context) {
    return Form(
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
            prefix: Icon(Icons.phone, color: Colors.white),
            controller: mobileController,
            labelText: lang.text("Mobile"),
            keyboardType: TextInputType.phone,
            validator: mobileValidator,
            textInputAction: TextInputAction.next,
            isPhoneNumber: true,
            countryCode: "249",
            fontColor: Colors.white,
          ),
//          _buildPasswordTextField(),
          SizedBox(height: 24),
          CustomButton(
            label: Text(lang.text('Reset')),
            onPressed: () {
              _submitButtonPressed();
            },
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  String mobileValidator(String value) {
    if (value.isEmpty) {
      return lang.text('This is required');
    } else if (!value.startsWith("249")) {
      return lang.text("Phone number must start with 249");
    }
    /*else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return lang.text('It should be an email');
    }*/
    return null;
  }

  void _submitButtonPressed() async {
    print('resetting');
    if (!_formKey.currentState.validate()) return;

    String mobile = mobileController.text;
    showLoadingDialog(context);
    Map<String, dynamic> response = await _repository.sendVerifyPin(mobile);
    print('reset password response: $response');
    Navigator.pop(context);
    if (response.containsKey("success") && response["success"]) {
      await _manager.set("temp_mobile", mobile);
      Navigator.pushNamed(context, RouteName.verify);
    }
  }
}
