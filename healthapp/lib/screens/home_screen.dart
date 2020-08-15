import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'package:healthapp/screens/chat_screen.dart';
import 'package:healthapp/screens/doctor_list.dart';
import 'package:healthapp/screens/drawer.dart';
import 'package:healthapp/screens/index.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // final String currentUserId;
//  HomeScreenState({Key key, @required this.currentUserId});

  // TODO show blogs in the homescreen in the form of cards
  int selectedIndex = 0;

  List<Text> headingOptions = [
    Text('Appointments'),
    Text('Chats'),
    Text('Video Call'),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      //TODO appointments + payments along with+ cancel and reschedule button

      //TODO: chats with doctor
      Doctor(),
      //TODO : video calling with doctor
      //push to chat screen
      ChatScreen(currentUserId: widget.currentUserId),

      IndexPage(),
    ];

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
