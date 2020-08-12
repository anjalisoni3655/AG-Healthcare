import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'home_screen.dart';
import 'user_details.dart';


class LoginPage extends StatefulWidget {
  @override
  static const id = "login_page";
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _googleSignInButton(),
              _appleSignInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _googleSignInButton() {
    return RaisedButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return UserForm();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      highlightElevation: 20,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/icons/google_logo.png"),
                height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black38,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appleSignInButton() {
    return RaisedButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      highlightElevation: 20,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/icons/apple_logo.png"),
                height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '  Sign in with Apple  ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black38,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
