import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:healthapp/authentication/user.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/screens/mobile_auth_screens/mobile_login_page.dart';
import 'package:healthapp/screens/user_profile.dart';
import 'package:healthapp/utils/settings.dart';
import 'package:healthapp/widgets/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/screens/upload_photo.dart';

SharedPreferences prefs;

List<Color> _textColor = [
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
];
List<Color> _bodyColor = [
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
];
List<String> _category = ['Male', 'Female', 'Other'];
DateTime selectedDate = DateTime.now();
String dropdownValue = 'O+';

String name;
String email;
String photo;
String gender;
String address;

int phone;
String dob='${selectedDate.toLocal()}'.split(' ')[0];
String blood = 'O+';
int height;
int weight;
String marital;

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
  final String currentUserId;

  UserForm({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextStyle textStyle1 = TextStyle(
      color: Color(0xFF8F8F8F), fontSize: 15, fontWeight: FontWeight.w600);
  TextStyle textStyle2 = TextStyle(
      color: Color(0xFF606060), fontSize: 15, fontWeight: FontWeight.w600);
  InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
  );

  Widget _buildName() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Your full name', style: textStyle1),
          ),
          TextFormField(
              decoration: inputDecoration,
              cursorColor: Color(0xFF8F8F8F),
              cursorRadius: Radius.circular(10),
              cursorWidth: 0.5,
              style: textStyle2,
              validator: validateName,
              onSaved: (String value) {
                name = value;
              }),
        ],
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Email Address', style: textStyle1),
          ),
          TextFormField(
              decoration: inputDecoration,
              cursorColor: Color(0xFF8F8F8F),
              cursorRadius: Radius.circular(10),
              cursorWidth: 0.5,
              style: textStyle2,
              validator: validateEmail,
              onSaved: (String value) {
                email = value;
              }),
        ],
      ),
    );
  }

  Widget _buildGender() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Gender', style: textStyle1),
          ),
          Row(
            children: [
              _customButton('Male', 18, 0, 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
              _customButton('Female', 18, 1, 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
              _customButton('Other', 18, 2, 20),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDOB(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Date of Birth', style: textStyle1),
          ),
          _getDateTime(context),
        ],
      ),
    );
  }

  Widget _buildBlood() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Blood Group', style: textStyle1),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(7)),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              isExpanded: true,
              underline: SizedBox(),
              style: TextStyle(
                  color: Color(0xFF606060),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  blood = dropdownValue;
                });
              },
              items: <String>['O+', 'O-', 'AB+', 'AB-', 'A+', 'A-', 'B+', 'B-']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeight() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Height', style: textStyle1),
          ),
          TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
                hintText: 'cm',
                hintStyle: TextStyle(
                    color: Color(0x6F8F8F8F),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              cursorColor: Color(0xFF8F8F8F),
              cursorRadius: Radius.circular(10),
              cursorWidth: 0.5,
              keyboardType: TextInputType.number,
              style: textStyle2,
              onSaved: (String value) {
                height = int.tryParse(value);
              }),
        ],
      ),
    );
  }

  Widget _buildWeight() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Weight', style: textStyle1),
          ),
          TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
                hintText: 'kg',
                hintStyle: TextStyle(
                    color: Color(0x6F8F8F8F),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              cursorColor: Color(0xFF8F8F8F),
              cursorRadius: Radius.circular(10),
              cursorWidth: 0.5,
              keyboardType: TextInputType.number,
              style: textStyle2,
              onSaved: (String value) {
                weight = int.tryParse(value);
              }),
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Address', style: textStyle1),
          ),
          TextFormField(
              decoration: inputDecoration,
              cursorColor: Color(0xFF8F8F8F),
              cursorRadius: Radius.circular(10),
              cursorWidth: 0.5,
              style: textStyle2,
              onSaved: (String value) {
                address = value;
              }),
        ],
      ),
    );
  }

  Widget _buildMarital() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Marital Status', style: textStyle1),
          ),
          TextFormField(
              decoration: inputDecoration,
              cursorColor: Color(0xFF8F8F8F),
              cursorRadius: Radius.circular(10),
              cursorWidth: 0.5,
              style: textStyle2,
              onSaved: (String value) {
                marital = value;
              }),
        ],
      ),
    );
  }

  Widget _customButton(String text, double tSize, int index, double padding) {
    return Expanded(
      child: RaisedButton(
        elevation: 0,
        padding: EdgeInsets.all(padding),
        color: _bodyColor[index],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: _getText(text, tSize, _textColor[index]),
        onPressed: () {
          gender = _category[index];
          print(gender);
          setState(() {
            if (_bodyColor[index] == Color(0xFFFFFFFF)) {
              _bodyColor[index] = Color(0xFFDFE9F7);
              _textColor[index] = Color(0xFF408AEB);
              int i = 0, j = 1;
              if (index == 0) {
                i = 1;
                j = 2;
              } else if (index == 1) {
                i = 0;
                j = 2;
              }
              _bodyColor[i] = Color(0xFFFFFFFF);
              _bodyColor[j] = Color(0xFFFFFFFF);
              _textColor[i] = Color(0xFF8F8F8F);
              _textColor[j] = Color(0xFF8F8F8F);
            } else {
              _bodyColor[index] = Color(0xFFFFFFFF);
              _textColor[index] = Color(0xFF8F8F8F);
            }
          });
        },
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: GoogleFonts.nunitoTextTheme(),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF408AEB),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob = '${selectedDate.toLocal()}'.split(' ')[0];
      });
  }

  Widget _getDateTime(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(context);
        print(dob);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: (selectedDate == null) ? Colors.white : Color(0xFFDFE9F7),
        ),
        child: Row(
          children: [
            (selectedDate == null)
                ? _getText('yyyy-mm-dd', 15, Color(0xFF8F8F8F))
                : _getText(dateTimeConverter('${selectedDate.toLocal()}'.split(' ')[0]), 15,
                    Color(0xFF408AEB)),
            Spacer(),
            Icon(Icons.calendar_today,
                color: (selectedDate == null)
                    ? Color(0xFF8F8F8F)
                    : Color(0xFF408AEB),
                size: 20),
          ],
        ),
      ),
    );
  }

  Widget _getText(String text, double size, Color color) {
    return Text(
      text,
      style:
          TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: customAppBar('', context),
      body: Material(
        color: Color(0xFFF8F8F8),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          color: Color(0xFFF8F8F8),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hello there!',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF08134D),
                      ),
                    ),
                    Text(
                      'Let\'s get your account set up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8F8F8F),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildName(),
                          _buildEmail(),
                          _buildGender(),
                          _buildDOB(context),
                          _buildBlood(),
                          _buildHeight(),
                          _buildWeight(),
                          _buildAddress(),
                          _buildMarital(),
                          Padding(
                            padding: EdgeInsets.all(150),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.65),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        key: Key('Submit'),
                        elevation: 10,
                        color: Colors.blue,
                        padding: EdgeInsets.all(15),
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          // If the form is valid , all the values are saved in respective variables
                          _formKey.currentState.save();

                          print(name);
                          print(email);
                          print(gender);
                          print(address);
                          print(dob);
                          print(blood);
                          print(height);
                          print(weight);
                          print(marital);
                          prefs = await SharedPreferences.getInstance();
                          final doc = await Firestore.instance
                              .collection('user_details')
                              .where('email', isEqualTo: email)
                              .getDocuments();
                          if (true) {
                            await globals.uploadUserDetails(
                              name: name,
                              email: email,
                              gender: gender,
                              address: address,
                              dob: dob,
                              blood: blood,
                              height: height,
                              weight: weight,
                              marital: marital,
                            );
                            await prefs.setString('gender', gender);
                            await prefs.setString('dob', dob);
                            await prefs.setString('gender', gender);
                            await prefs.setString('dob', dob);
                            await prefs.setString('blood', blood);
                            await prefs.setString('height', height.toString());
                            await prefs.setString('weight', weight.toString());
                            await prefs.setString('marital', marital);
                            await prefs.setString('address', address);
                          }
                          // Navigator.pushNamed(context, UploadPhoto.id);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadPhoto(
                                      currentUserId: widget.currentUserId)));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(7)),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
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
