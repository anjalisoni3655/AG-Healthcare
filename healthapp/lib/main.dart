import 'package:flutter/material.dart';
import 'package:healthapp/screens/chat.dart';
import 'package:healthapp/screens/disease.dart';
import 'package:healthapp/screens/doctor_list.dart';
import 'package:healthapp/screens/login_screen.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:healthapp/screens/user_details.dart';
import 'package:healthapp/screens/profile.dart';
import 'package:healthapp/screens/index.dart';
import 'package:healthapp/screens/chat.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AG Hospital',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(title:'log in'),
        // initialRoute: LoginPage.id,
        routes: {
          IndexPage.id:(context)=>IndexPage(),
          UserForm.id: (context) => UserForm(),
          LoginPage.id: (context) => LoginPage(),
        // HomeScreen.id: (context) => HomeScreen(),
           Profile.id: (context) => Profile(),
           Disease.id:(context)=>Disease(),
           Doctor.id:(context)=>Doctor(),
         //Chat.id:(context)=>Chat(),


        });
  }
}
