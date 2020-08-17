import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'package:healthapp/authentication/facebook_login.dart';
import 'profile.dart';
import 'login_screen.dart';
import "package:provider/provider.dart";
import 'package:healthapp/stores/login_store.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

String type;

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    String name = f_name, email = f_email, imageUrl = f_imageUrl;
    if (type == 'Google') {
      name = g_name;
      email = g_email;
      imageUrl = g_imageUrl;
    }
    if (name != null) name = name.split(" ")[0];
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Drawer(
        child: Container(
          color: Colors.blue,
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              //TODO :Make this dynamic later!
              CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    (imageUrl != null)
                        ? imageUrl
                        : 'https://unsplash.com/photos/rDEOVtE7vOs',
                  ),
                ),
                radius: 40,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 20),
              Container(
                child: Center(
                  child: Text(
                    (name != null) ? 'Hi $name!' : 'Hi AB',
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
                    (email != null) ? '$email' : 'absatyaprakash01@gmail.com',
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
                  Icons.work,
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
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onTap: () {
                  loginStore.signOut(context);
                  if (type == 'Google')
                    signOutGoogle();
                  else
                    signOutFacebook();
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
    });
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
