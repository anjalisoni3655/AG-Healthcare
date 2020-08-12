import 'package:flutter/material.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:healthapp/authentication/user.dart';

String name;
String email;
String gender;
String address;
int age;
int phone;

String validateAge(String age) {
  Pattern pattern = r'[.,|_]';
  RegExp regex = RegExp(pattern);
  if (age.isEmpty) {
    return 'This field cannot be empty';
  } else {
    if (regex.hasMatch(age)) {
      return 'Please enter a valid phone no.';
    } else {
      int num = int.parse(age);
      if (num > 0 && num < 100) {
        return null;
      } else
        return 'Please enter a valid age';
    }
  }
}

String validatePhone(String phone) {
  Pattern pattern = r'[.,|_]';
  RegExp regex = RegExp(pattern);
  if (phone.isEmpty) {
    return 'This field cannot be empty';
  } else {
    if (regex.hasMatch(phone)) {
      return 'Please enter a valid phone no.';
    } else {
      int num = int.parse(phone);
      if (num > 1000000000 && num < 9999999999) {
        return null;
      } else
        return 'Please enter a valid phone no.';
    }
  }
}

String validateAddress(String value) {
  if (value.isEmpty) {
    return 'This Field cannot be empty';
  } else if (value.contains(RegExp(r'[A-Z]')) ||
      value.contains(RegExp(r'[a-z]')) ||
      value.contains(RegExp(r'-,/\\()'))) {
    return null;
  } else {
    return 'Please enter a valid address';
  }
}

String validateEmail(String value) {
  if (value.isEmpty) {
    return 'This Field cannot be empty';
  } else if (value.contains(RegExp(r'[A-Z]')) ||
      value.contains(RegExp(r'[a-z]')) ||
      value.contains(RegExp(r'-,/\\()'))) {
    return null;
  } else {
    return 'Please enter a valid email';
  }
}

String validateName(String value) {
  if (value.isEmpty) {
    return 'This Field cannot be empty';
  } else if (value.contains(RegExp(r'[A-Z]')) ||
      value.contains(RegExp(r'[a-z]'))) {
    return null;
  } else {
    return 'Please enter a valid name';
  }
}

String validateGender(String value) {
  if (value.isEmpty) {
    return 'This Field cannot be empty';
  } else if (value == 'M' || value == 'F' || value == 'O') {
    return null;
  } else {
    return 'Please enter a valid gender';
  }
}

// Widget for getting , validating and storing User Address
class UserForm extends StatefulWidget {
  static const id = "user";
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildAddress() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Address"),
        validator: validateAddress,
        onSaved: (String value) {
          address = value;
        });
  }

  Widget _buildName() {
    return TextFormField(
        decoration: InputDecoration(labelText: " Name "),
        validator: validateAddress,
        onSaved: (String value) {
          name = value;
        });
  }

  Widget _buildAge() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Age"),
        validator: validateAge,
        keyboardType: TextInputType.number,
        onSaved: (String value) {
          age = int.tryParse(value);
        });
  }

  Widget _buildEmail() {
    return TextFormField(
        decoration: InputDecoration(labelText: " email "),
        validator: validateEmail,
        onSaved: (String value) {
          email = value;
        });
  }

  Widget _buildPhone() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Mobile No."),
        keyboardType: TextInputType.number,
        validator: validatePhone,
        onSaved: (String value) {
          phone = int.tryParse(value);
        });
  }

  Widget _buildGender() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Gender(M/F/O)"),
        validator: validateGender,
        onSaved: (String value) {
          gender = value;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
        //  backgroundColor: kAppbarColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildName(),
                    _buildEmail(),
                    _buildPhone(),
                    _buildAddress(),
                    _buildAge(),
                    _buildGender(),
                    SizedBox(height: 100),
                    RaisedButton(
                      key: Key('Submit'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        // If the form is valid , all the values are saved in respective variables
                        _formKey.currentState.save();
                        User user = User(
                          name,
                          email,
                          age,
                          gender,
                          address,
                          phone,
                        );
                        //Available policies corresponding to the pincode is saved in list .

                        Navigator.pushReplacementNamed(context, HomeScreen.id,
                            arguments: {
                              'user': user,
                            });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          //color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
