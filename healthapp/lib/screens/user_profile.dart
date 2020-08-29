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
String gender, dob, blood, marital, address, name, email;
String height, weight,photo;

class UserProfile extends StatefulWidget {
  @override
  static const id = "userProfile_page";

  UserProfileState createState() => UserProfileState();
}
SharedPreferences prefs;

class UserProfileState extends State<UserProfile> {
  /*Future<void> getPatient() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("user_details")
        .document(firebaseUser.email)
        .get()
        .then((value) {
      print(value.data);
      gender = value.data['gender'];
      dob = value.data['dob'];
      blood = value.data['blood'];
      height = value.data['height'];
      weight = value.data['weight'];
      marital = value.data['marital'];
      address = value.data['address'];
      name = value.data['name'];
      email = value.data['email'];

      //  print(value.data["address"]["city"]);
      print(value.data["address"]);
    });
  }*/
   

  

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
name = prefs.getString('name') ?? globals.user.name;
    email = prefs.getString('email') ?? globals.user.email;
    photo = prefs.getString('photo') ?? globals.user.photo;
    gender = prefs.getString('gender') ?? globals.user.gender;
    dob = prefs.getString('dob') ?? globals.user.dob;
    blood = prefs.getString('blood') ?? globals.user.blood;
    height = prefs.getString('height') ?? globals.user.height;
  weight= prefs.getString('dob') ?? globals.user.weight;
    marital = prefs.getString('marital') ?? globals.user.marital;
    address = prefs.getString('address') ?? globals.user.address;
    

    email = email.split('@')[0];
   
    // Force refresh input
    setState(() {
       
    });
  }

  @override
  void initState() {
    readLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    
   

   // print('gender$gender');
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
                      _text(name, Color(0xFF08134D), FontWeight.w700, 29, 0),
                      _text(email, Color(0xFF08134D), FontWeight.w700, 15, 5),
                      _text('9937590845', Color(0xFF08134D), FontWeight.w700,
                          15, 0),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      _information('Gender', gender),
                      _information('Date of Birth', dob),
                      _information('Blood Group', blood),
                      _information('Height', (height).toString() + ' cm'),
                      _information('Weight', (weight).toString() + ' kg'),
                      _information('Marital Status', marital),
                      _information('Address', address),
                    ],
                  )
                : Column(),
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
