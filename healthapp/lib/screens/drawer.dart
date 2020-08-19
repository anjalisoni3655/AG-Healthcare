import 'package:flutter/cupertino.dart';
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
    if (email != null) email = email.split("@")[0];
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(
            children: [
              //TODO :Make this dynamic later!
              Container(
                color: Colors.blue[700],
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            (imageUrl != null)
                                ? imageUrl
                                : 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=80',
                          ),
                        ),
                        radius: 50,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Text(
                              (name != null) ? '$name' : 'Kate Williams',
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
                              (email != null)
                                  ? '$email \n@gmail.com'
                                  : 'katewilliams01 \n @gmail.com',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  Icons.assignment,
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
              Divider(
                thickness: 1,
                color: Colors.white,
              ),
              ListTileWidget(
                text: 'Support',
                icon: Icon(
                  Icons.headset_mic,
                  color: Colors.white,
                ),
                onTap: () {},
              ),
              ListTileWidget(
                text: 'Terms of Use',
                icon: Icon(
                  Icons.speaker_notes,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Profile.id);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: ListTileWidget(
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
