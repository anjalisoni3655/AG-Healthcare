import 'package:flutter/material.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/stores/login_store.dart';
import 'package:healthapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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