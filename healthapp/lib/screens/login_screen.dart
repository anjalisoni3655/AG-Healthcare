import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'home_screen.dart';
import 'user_details.dart';

const List<String> login_types = [' Google ', 'Facebook'];
const List<AssetImage> login_icons = [
  AssetImage('assets/icons/google.png'),
  AssetImage('assets/icons/facebook.png')
];

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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _SignInWithMobile(),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _SignInButton(login_types[0], login_icons[0]),
                    Padding(
                      padding: EdgeInsets.all(15),
                    ),
                    _SignInButton(login_types[1], login_icons[1]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _SignInWithMobile() {
    return RaisedButton(
      splashColor: Colors.grey,
      onPressed: () {
        //TODO: Implement Mobile Phone Login
        print('Implement Mobile Phone Login');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      highlightElevation: 20,
      color: Colors.blue[800],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Continue With Phone Number',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _SignInButton(String text, AssetImage assetImage) {
    return RaisedButton(
      splashColor: Colors.grey,
      onPressed: () {
        if (text == login_types[0]) {
          signInWithGoogle().whenComplete(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return UserForm();
                },
              ),
            );
          });
        } else {
          // TODO: Facebook Login!
          print('Implement Facebook Login');
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      highlightElevation: 20,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: assetImage, height: 20.0),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[800],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
