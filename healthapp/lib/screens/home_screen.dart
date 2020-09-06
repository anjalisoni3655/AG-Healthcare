import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/appointments/upcoming_page.dart';
import 'package:healthapp/screens/blogs/blogs_page.dart';
import 'package:healthapp/screens/drawer.dart';
import 'package:healthapp/screens/home/home_page.dart';
import 'package:healthapp/screens/chat_screen.dart';
import 'package:healthapp/authentication/user.dart' as globals;

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Text> headingOptions = [
    Text(
      'Home',
      style: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF262626),
      ),
    ),
    Text(
      'My Bookings',
      style: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF262626),
      ),
    ),
    Text(
      'All Blogs',
      style: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF262626),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      HomePage(),
      ChatScreen(currentUserId: widget.currentUserId),
      BlogsPage(),
    ];
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: AppBar(
            iconTheme: new IconThemeData(color: Color(0xFF408AEB)),
            title: headingOptions[selectedIndex],
            backgroundColor: Color(0xFFF8F8F8),
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ),
        drawer: DrawerWidget(),
        body: widgetOptions[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFF408AEB),
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 25,
              ),
              title: Text(
                'Home',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.work,
                size: 25,
              ),
              title: Text(
                'Appointments',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble,
                size: 25,
              ),
              title: Text(
                'Blogs',
              ),
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int i) {
            globals.getPatientofGivenBookingId();
            setState(() {
              selectedIndex = i;
            });
          },
        ),
      ),
    );
  }
}
