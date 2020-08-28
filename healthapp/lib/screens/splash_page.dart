import 'package:flutter/material.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/stores/login_store.dart';
import 'package:healthapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/authentication/user.dart' as globals;

SharedPreferences prefs;

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
        globals.user.photo = prefs.getString('photoUrl');
        globals.user.name = prefs.getString('name');

        print('EMAIL:${globals.user.email}');
        print(globals.user.photo);
        print(globals.user.name);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) =>
                    HomeScreen(currentUserId: prefs.getString('id'))),
            (Route<dynamic> route) => false);
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
