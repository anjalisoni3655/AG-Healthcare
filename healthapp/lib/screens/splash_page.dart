import 'package:flutter/material.dart';
import 'package:healthapp/screens/appointments/upcoming_page.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/stores/login_store.dart';
import 'package:healthapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/authentication/user.dart' as globals;
import 'package:healthapp/screens/chat_screen.dart';
import 'package:healthapp/screens/doctor_pages/doc_chat.dart';

SharedPreferences prefs;
String UserId;

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    prefs = await SharedPreferences.getInstance();

    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        globals.user.email = prefs.getString('email');
        globals.user.photo = prefs.getString('photo');
        globals.user.name = prefs.getString('name');
        //       //TODO : also take the phone number
        //         globals.user.marital = prefs.getString('marital');
        //    globals.user.address =prefs.getString('address');
        //    globals.user.gender = prefs.getString('gender');
        //    globals.user.dob = prefs.getString('dob');
        //   globals.user.blood =prefs.getString('blood');
        // globals.user.weight = prefs.getString('weight');
        //    globals.user.height = prefs.getString('height');
        globals.user.id = prefs.getString('id');

        //TODO: also add the reason of visting

        print('EMAIL:${globals.user.email}');
        print(globals.user.photo);
        print(globals.user.name);
        // if (globals.user.email != "anjalisoni3655@gmail.com") {
        /*  if (globals.user.id == 'HxotQtogDhYYb9wW4EbyqV3Vd1x1') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DocChatScreen(
                        UserId: 'HxotQtogDhYYb9wW4EbyqV3Vd1x1',
                      ))); */
//  Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: (_) =>
//                       DocChatScreen(UserId: 'HxotQtogDhYYb9wW4EbyqV3Vd1x1')),
//               (Route<dynamic> route) => false);
        // } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) =>
                    HomeScreen(currentUserId: prefs.getString('id'))),
            (Route<dynamic> route) => false);
        // }
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
