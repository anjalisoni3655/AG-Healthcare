import 'package:healthapp/screens/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/screens/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/screens/edit_profile.dart';
import 'package:healthapp/authentication/user.dart' as globals;

String type;
String gender, dob, bloodGroup, maritalStatus, address, name, email;
int height, weight;

class UserProfile extends StatefulWidget {
  @override
  static const id = "userProfile_page";

  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  void getPatient() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("user_details")
        .document(firebaseUser.email)
        .get()
        .then((value) {
      print(value.data);
      gender = value.data['gender'];
      dob = value.data['dob'];
      bloodGroup = value.data['blood'];
      height = value.data['height'];
      weight = value.data['weight'];
      maritalStatus = value.data['marital'];
      address = value.data['address'];
      name = value.data['name'];
      email = value.data['email'];

      //  print(value.data["address"]["city"]);
      print(value.data["address"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    getPatient();
    globals.user.maritalStatus = maritalStatus;
    globals.user.address =address;
    globals.user.gender = gender;
    globals.user.dob = dob;
    globals.user.bloodGroup = bloodGroup;
    globals.user.weight = weight;
    globals.user.height = height;


    print('gender$gender');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: (globals.user.photo != null)
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            image: NetworkImage(globals.user.photo),
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      _text(globals.user.name, Color(0xFF08134D),
                          FontWeight.w700, 29, 0),
                      _text(globals.user.email, Color(0xFF08134D),
                          FontWeight.w700, 15, 5),
                      _text('9937590845', Color(0xFF08134D), FontWeight.w700,
                          15, 0),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      _information('Gender', globals.user.gender),
                      _information('Date of Birth', globals.user.dob),
                      _information('Blood Group', globals.user.bloodGroup),
                      _information('Height', (globals.user.height).toString() + ' cm'),
                      _information('Weight', (globals.user.height).toString() + ' kg'),
                      _information('Marital Status',globals.user.maritalStatus ),
                      _information('Address', globals.user.address),
                    ],
                  )
                : Column(),
          ),
        ),
      ),
    );
  }

  Widget _information(String category, String value) {
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
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'My Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF262626),
        ),
      ),
      leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
