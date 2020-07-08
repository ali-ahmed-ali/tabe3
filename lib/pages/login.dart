import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/widget/custom_edit_text.dart';
import 'package:tabee/widget/custome_button.dart';
import 'package:tabee/widget/dialog_utils.dart';

class LoginPage extends StatelessWidget {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();

  BuildContext context;

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
              Colors.black.withOpacity(.5),
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
//          _buildEmailTextField(),
          CustomEditText(
            prefix: Icon(Icons.person_outline, color: Colors.white),
            focusNode: emailFocusNode,
            controller: emailController,
            labelText: lang.text("Email address"),
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            validator: emailValidator,
            fontColor: Colors.white,
          ),
//          _buildPasswordTextField(),
          CustomEditText(
            focusNode: passwordFocusNode,
            controller: passwordController,
            labelText: lang.text("Password"),
            keyboardType: TextInputType.emailAddress,
            validator: emailValidator,
            fontColor: Colors.white,
            textInputAction: TextInputAction.done,
            isPassword: true,
            prefix: Icon(Icons.lock_outline, color: Colors.white),
          ),
          SizedBox(height: 30),
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
    );
  }

  String emailValidator(String value) {
    if (value.isEmpty) {
      return lang.text('This is requird');
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return lang.text('It should be an email');
    }
    return null;
  }

  void _submitButtonPressed() async {
    print('logging in');
    if (!_formKey.currentState.validate()) {
      return;
    }
    showLoadingDialog(context);
    //check user here
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, RouteName.home);
    });
  }
}
