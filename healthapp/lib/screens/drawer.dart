import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthapp/screens/appointments/upcoming_page.dart';
import 'package:healthapp/screens/blogs/blogs_page.dart';
import 'package:healthapp/screens/chat_screen.dart';
import 'package:healthapp/screens/user_profile.dart';
import 'login_screen.dart';
import "package:provider/provider.dart";
import 'package:healthapp/stores/login_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/authentication/user.dart' as globals;
import 'package:healthapp/screens/edit_profile.dart';
import 'package:share/share.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

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

    name = prefs.getString('name') ?? globals.user.name;
    email = prefs.getString('email') ?? globals.user.email;
    photo = prefs.getString('photo') ?? globals.user.photo;
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
    // getPatient();
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              //TODO :Make this dynamic later!
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, UserProfile.id);
                },
                child: Container(
                  color: Colors.blue[700],
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          child: ClipOval(
                            child: Image.network(
                              (photo != null) ? photo : globals.user.photo,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          radius: 40,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              (name != null) ? '$name' : 'Kate Williams',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              (email != null)
                                  ? '${email.split('@')[0]}'
                                  : 'katewilliams01',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'My appointments',
                  style: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                leading: Icon(
                  Icons.work,
                  color: Color(0xFF408AEB),
                ),
                onTap: () {
                  Navigator.pushNamed(context, ChatScreen.id);
                },
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Blogs',
                  style: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                leading: Icon(
                  Icons.edit,
                  color: Color(0xFF408AEB),
                ),
                onTap: () {
                  Navigator.pushNamed(context, BlogsPage.id);
                },
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Refer a friend',
                  style: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                leading: Icon(
                  Icons.group,
                  color: Color(0xFF408AEB),
                ),
                onTap: () {
                  Share.share(
                      'Visit my website https://medicaregalaxy.vercel.app/',
                      subject: 'Install this app Now!');
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  thickness: 1,
                  color: Color(0x4F8F8F8F),
                  indent: 20,
                  endIndent: 20,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Others',
                    style: TextStyle(
                        color: Color(0xFF262626),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
              ListTile(
                dense: true,
                title: Text(
                  'Contact Us',
                  style: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                leading: Icon(
                  Icons.headset_mic,
                  color: Color(0xFF408AEB),
                ),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                title: Text(
                  'About us',
                  style: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                leading: Icon(
                  Icons.work,
                  color: Color(0xFF408AEB),
                ),
                onTap: () {
                },
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                leading: Icon(
                  Icons.speaker_notes,
                  color: Color(0xFF408AEB),
                ),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Refund/Cancellation Policy',
                  style: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                leading: Icon(
                  Icons.cancel,
                  color: Color(0xFF408AEB),
                ),
                onTap: () {
                },
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                leading: Icon(
                  Icons.library_books,
                  color: Color(0xFF408AEB),
                ),
                onTap: () {
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        color: Color(0xFF8F8F8F),
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  leading: FaIcon(
                    FontAwesomeIcons.arrowCircleLeft,
                    color: Color(0xFF408AEB),
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
