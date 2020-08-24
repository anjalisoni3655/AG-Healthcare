import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'package:healthapp/screens/mobile_auth_screens/mobile_login_page.dart';
import 'package:healthapp/authentication/facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> login_types = ['Google', 'Facebook'];
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
    return Material(
      child: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'assets/images/login.png',
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                      colors: [
                        Colors.blue[200].withOpacity(0.0),
                        Colors.blue[900],
                      ],
                    )),
              )
            ]),
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/icons/stethoscope.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6),
                    ),
                    Text(
                      'Dr. Amit Goel',
                      style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 29.0,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6),
                    ),
                    Text(
                      'Endocrinologist in Hyderabad',
                      style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    Divider(
                      thickness: 1.5,
                      indent: 90.0,
                      endIndent: 90.0,
                      color: Colors.blue[700],
                    ),
                    Text(
                      'Comprehensive Diabetes \n       & Endo care Clinic',
                      style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(child: _SignInWithMobile()),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: _SignInButton(login_types[1], login_icons[1])),
                      Padding(padding: EdgeInsets.all(10),),
                      Expanded(child: _SignInButton(login_types[0], login_icons[0])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _SignInWithMobile() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context){
            return MobileLoginPage();
          }
        ));
        //TODO: Implement Mobile Phone Login
        print('Implement Mobile Phone Login');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      color: Color(0xFF408AEB),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Continue With Phone Number',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
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
                  return MobileLoginPage();
                },
              ),
            );
          });
        } else {
          // TODO: Facebook Login!
          print('Implement Facebook Login');
          signInWithFacebook().whenComplete(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MobileLoginPage();
                },
              ),
            );
          });
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
                  color: Colors.blue[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
