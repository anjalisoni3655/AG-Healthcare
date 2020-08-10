import 'package:flutter/material.dart';
import 'package:healthapp/screens/login_screen.dart';
import 'package:healthapp/screens/home_screen.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dr.AG Hospital',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
        // initialRoute: LoginPage.id,
        routes: {
          LoginPage.id: (context) => LoginPage(),
          HomeScreen.id:(context)=>HomeScreen(),
          
        });
  }
}
