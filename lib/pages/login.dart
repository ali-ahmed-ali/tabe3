import 'package:flutter/material.dart';
import 'package:tabee/config/router_manager.dart';
import 'package:tabee/pages/signup.dart';
import 'package:tabee/utils/lang.dart';

class LoginPage extends StatelessWidget {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(169, 221, 243, 1),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(.3),
              Theme.of(context).primaryColor.withOpacity(.8),
              Colors.black.withOpacity(.7)
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
                lang.text('تسجيل الدخول'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 20),
              child: Image.asset('assets/images/logowhite.png'),
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildEmailTextField(),
          SizedBox(
            height: 10.0,
          ),
          _buildPasswordTextField(),
          SizedBox(
            height: 60.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              elevation: 3,
              splashColor: Colors.lightGreenAccent,
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              child: Text(lang.text('Login')),
              onPressed: () {
                Navigator.pushReplacementNamed(context, RouteName.table);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                lang.text("'Don\'t an account?"),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Signup(),
                    ),
                  );
                },
                child: Text(
                  lang.text('Sign up'),
                  style: TextStyle(color: Colors.lightGreenAccent),
                ),
              ),
            ],
          )
        ],
      ),
    );
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
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_outline),
        labelText: lang.text('E-mail'),
        filled: true,
        fillColor: Colors.white,
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

  void _submetButtonPressed() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    //check user here
//    Navigator.pushReplacementNamed(context, '/home');
  }
}
