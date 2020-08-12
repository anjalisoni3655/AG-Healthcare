import 'package:flutter/material.dart';
import 'package:healthapp/authentication/user.dart';
class Profile extends StatelessWidget {
  static const id ="profile";
  User user;
Profile({this.user});
@override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('user.name', style: TextStyle(fontSize: 22)),
            Text('user.email', style: TextStyle(fontSize: 22)),
            Text('user.address', style: TextStyle(fontSize: 22)),
            Text('user.gender', style: TextStyle(fontSize: 22)),
         //   Text(user.age, style: TextStyle(fontSize: 22)),
          //  Text(user.phone, style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
    ));
  }
}