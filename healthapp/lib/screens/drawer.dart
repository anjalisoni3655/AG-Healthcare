import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'profile.dart';
import 'login_screen.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(10.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //TODO :circle avatar
            CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  g_imageUrl,
                ),
              ),
              radius: 40,
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 20),
            Container(
              child: Center(
                child: Text(
                  'Hi $g_name!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: Text(
                  '$g_email',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTileWidget(
              text: 'My Appointments',
              icon: Icon(
                Icons.settings_applications,
                color: Colors.white,
              ),
              onTap: () {},
            ),
            ListTileWidget(
              text: 'My prescriptions',
              icon: Icon(
                Icons.speaker_notes,
                color: Colors.white,
              ),
              onTap: () {},
            ),
            ListTileWidget(
              text: 'My payments',
              icon: Icon(
                Icons.payment,
                color: Colors.white,
              ),
              onTap: () {},
            ),

            ListTileWidget(
              text: 'Edit Profile',
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushNamed(context, Profile.id);
              },
            ),

            ListTileWidget(
              text: 'Contact Available doctor',
              icon: Icon(
                Icons.contacts,
                color: Colors.white,
              ),
              onTap: () {},
            ),
            ListTileWidget(
              text: 'About the Hospital',
              icon: Icon(
                Icons.local_hospital,
                color: Colors.white,
              ),
              onTap: () {},
            ),
            ListTileWidget(
              text: 'Signout',
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onTap: () {
                signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }), ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({@required this.text, @required this.icon, this.onTap});
  final String text;
  final Icon icon;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: Text(text, style: TextStyle(color: Colors.white)),
        leading: icon,
        onTap: onTap,
      ),
    );
  }
}
