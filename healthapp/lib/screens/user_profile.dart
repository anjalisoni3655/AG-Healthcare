import 'package:healthapp/screens/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  @override
  static const id = "userProfile_page";

  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  SharedPreferences prefs;

  String name;
  String email;
  String photo;

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name') ?? '';
    email = prefs.getString('email') ?? '';
    photo = prefs.getString('photoUrl') ?? '';
    photo = photo.substring(0, photo.length - 5) + 's400-c';
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
            child: (photo != null)
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            image: NetworkImage(photo),
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
                      _information('Blood Group', bloodGroup),
                      _information('Height', height.toString() + ' cm'),
                      _information('Weight', weight.toString() + ' kg'),
                      _information('Marital Status', maritalStatus),
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
