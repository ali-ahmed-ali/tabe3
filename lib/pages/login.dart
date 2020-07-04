import 'package:flutter/material.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/widget/custom_edit_text.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(169, 221, 243, 1),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme
                  .of(context)
                  .primaryColorDark,
              Colors.black.withOpacity(.5),
              Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(.9),
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
            hint: lang.text("Email address"),
          ),
//          _buildPasswordTextField(),
          CustomEditText(
            focusNode: passwordFocusNode,
            controller: passwordController,
            labelText: lang.text("Email address"),
            keyboardType: TextInputType.emailAddress,
            validator: emailValidator,
            fontColor: Colors.white,
            hint: lang.text("Email address"),
            isPassword: true,
            prefix: Icon(Icons.lock_outline, color: Colors.white),
          ),
          SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              elevation: 3,
              splashColor: Colors.lightGreenAccent,
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              child: Text(lang.text('Sign in')),
              onPressed: () => _submitButtonPressed(context),
            ),
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

  Widget _buildEmailTextField() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return lang.text('This is requird');
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return lang.text('It should be an email');
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      onFieldSubmitted: (value) {},
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
          labelText: lang.text('E-mail'),
          labelStyle: TextStyle(color: Colors.white)
//        filled: true,
//        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return lang.text('This is required');
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        labelText: lang.text('password'),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  void _submitButtonPressed(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    //check user here
    Navigator.pushReplacementNamed(context, 'home');
  }
}
