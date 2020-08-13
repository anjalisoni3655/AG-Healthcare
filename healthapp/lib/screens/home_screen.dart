import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'package:healthapp/screens/disease.dart';
import 'package:healthapp/screens/drawer.dart';
import 'package:healthapp/screens/index.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO show blogs in the homescreen in the form of cards
  int selectedIndex = 0;

  List<Widget> widgetOptions = [
    //TODO appointments + payments along with+ cancel and reschedule button
    
    //TODO: chats with doctor
    Disease(),
    //TODO : video calling with doctor
    Container(
      color: Colors.white,
    ),
    
      IndexPage(),
    
  ];
  List<Text> headingOptions = [
    Text('Appointments'),
    Text('Chats'),
    Text('Video Call'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
          child: AppBar(
            title: headingOptions[selectedIndex],
            backgroundColor: Colors.blue,
          ),
        ),
        drawer: DrawerWidget(),
        body: widgetOptions[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility),
              title: Text('Appointments'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.change_history),
              title: Text('Chats'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_call),
              title: Text('Video Call'),
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
