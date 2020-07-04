import 'package:flutter/material.dart';
import '../utils/lang.dart';

class Signup extends StatelessWidget {
  final Map<String, dynamic> _formData = {
    'name': null,
    'class': null,
    'age': null,
    'health':null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'assets/images/logoblue.png',
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildUsernameTextField(),
          SizedBox(
            height: 10.0,
          ),
          _buildClassTextField(),
          SizedBox(
            height: 10.0,
          ),
          _buildAgeTextField(),
          SizedBox(
            height: 10.0,
          ),
          _buildHealthTextField(),
          SizedBox(
            height: 20.0,
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
              child: Text(lang.text('Rigester')),
              onPressed: () => _submetButtonPressed(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  Widget _buildClassTextField() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return lang.text('This is requird');
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.school),
        labelText: lang.text('Class'),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData['class'] = value;
      },
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return lang.text('This is requird');
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
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
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.local_hospital),
        labelText: lang.text('Health Status'),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData['health'] = value;
      },
    );
  }

  void _submetButtonPressed() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    //check user here
    //Navigator.pushReplacementNamed(context, '/home');
  }
}
