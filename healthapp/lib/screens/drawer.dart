import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'package:healthapp/authentication/facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthapp/screens/appointments/appointments_page.dart';
import 'edit_profile.dart';
import 'login_screen.dart';
import "package:provider/provider.dart";
import 'package:healthapp/stores/login_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

String type;

class _DrawerWidgetState extends State<DrawerWidget> {
  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  SharedPreferences prefs;

  String name;
  String email;
  String photo;
  void readLocal() async {
    prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name') ?? '';
    email = prefs.getString('email') ?? '';
    photo = prefs.getString('photoUrl') ?? '';

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
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Drawer(
        child: Container(
          color: Colors.black87,
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              //TODO :Make this dynamic later!
              Container(
                color: Colors.blue[700],
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            (photo != null)
                                ? photo
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
                                  ? '$email'
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
                onTap: () {
                  Navigator.pushNamed(context, AppointmentPage.id);
                },
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
                    handleSignOut();
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
