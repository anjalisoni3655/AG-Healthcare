import 'package:flutter/material.dart';
import 'package:healthapp/screens/appointment_page.dart';
import 'package:healthapp/screens/drawer.dart';
import 'package:healthapp/screens/home/home_page.dart';
import 'package:healthapp/screens/mobile_auth_screens/otp_page.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Widget> widgetOptions = [
    HomePage(),
    Container(
      color: Colors.white,
    ),
    Container(
      color: Colors.white,
    ),
  ];
  List<Text> headingOptions = [
    Text(
      'Home',
    ),
    Text(
      'Appointments',
    ),
    Text(
      'Blogs',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: AppBar(
            title: headingOptions[selectedIndex],
            backgroundColor: Colors.blue[700],
          ),
        ),
        drawer: DrawerWidget(),
        body: widgetOptions[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue[700],
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'Home',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              title: Text(
                'Appointments',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              title: Text(
                'Blogs',
              ),
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int i) {
            setState(() {
              selectedIndex = i;
            });
          },
        ),
      ),
    );
  }
}
