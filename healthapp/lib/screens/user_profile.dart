import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:healthapp/utils/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/screens/edit_profile.dart';
import 'package:healthapp/authentication/user.dart' as globals;

import 'home/home_page.dart';

String type;
String gender, dob, blood, marital, address, name, email;
String height, weight, photo;

class UserProfile extends StatefulWidget {
  @override
  static const id = "userProfile_page";

  UserProfileState createState() => UserProfileState();
}

SharedPreferences prefs;

class UserProfileState extends State<UserProfile> {

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? globals.user.name;
    email = prefs.getString('email') ?? globals.user.email;
    photo = prefs.getString('photo') ?? globals.user.photo;
    gender = prefs.getString('gender') ?? globals.user.gender;
    dob = prefs.getString('dob') ?? globals.user.dob;
    blood = prefs.getString('blood') ?? globals.user.blood;
    height = prefs.getString('height') ?? globals.user.height;
    weight = prefs.getString('dob') ?? globals.user.weight;
    marital = prefs.getString('marital') ?? globals.user.marital;
    address = prefs.getString('address') ?? globals.user.address;

    email = email.split('@')[0];

    // Force refresh input
    setState(() {});
  }

  @override
  void initState() {
    readLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: NetworkImage(photo),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _text(name, Color(0xFF08134D), FontWeight.w700, 29, 0),
                _text(email, Color(0xFF08134D), FontWeight.w700, 15, 5),
                _text('9937590845', Color(0xFF08134D), FontWeight.w700, 15, 0),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                _information('Gender', gender),
                _information('Date of Birth', dateTimeConverter(dob)),
                _information('Blood Group', blood),
                _information('Height', (height).toString() + ' cm'),
                _information('Weight', (weight).toString() + ' kg'),
                _information('Marital Status', marital),
                _information('Address', address),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _information(String category, String value) {
    //  getPatient();
    return Container(
      child: Row(
        children: [
          _text(category, Color(0xFF8F8F8F), FontWeight.w600, 15, 7),
          Spacer(),
          _text(value, Color(0xFF606060), FontWeight.w600, 15, 7),
        ],
      ),
    );
  }

  Widget _text(String text, Color color, FontWeight fontWeight, double fontSize,
      double padding) {
    //getPatient();
    print(name);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    // getPatient();
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'My Profile',
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF262626),
        ),
      ),
      leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, HomeScreen.id);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue[700],
          )),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xFFDFE9F7), borderRadius: BorderRadius.circular(7)),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Profile.id);
              print('EditProfile to go to');
            },
            child: Icon(
              Icons.edit,
              size: 24,
              color: Color(0xFF007CC2),
            ),
          ),
        ),
      ],
    );
  }
}
