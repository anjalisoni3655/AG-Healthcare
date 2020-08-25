import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/appointments/appointments_page.dart';
import 'package:healthapp/screens/blogs/blogs_page.dart';
import 'package:healthapp/screens/book_appointments/appointment_details.dart';
import 'package:healthapp/screens/book_appointments/doctor_details.dart';
import 'package:healthapp/screens/book_appointments/doctors_list.dart';
import 'package:healthapp/screens/login_screen.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:healthapp/screens/user_details.dart';
import 'package:healthapp/screens/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/screens/splash_page.dart';
import 'package:healthapp/stores/login_store.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //what is this doing?
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AG Hospital',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: SplashPage(),
        routes: {
          LoginPage.id: (context) => LoginPage(),
          UserForm.id: (context) => UserForm(),
          LoginPage.id: (context) => LoginPage(),
          HomeScreen.id: (context) => HomeScreen(),
          Profile.id: (context) => Profile(),
          AppointmentPage.id: (context) => AppointmentPage(),
          BlogsPage.id: (context) => BlogsPage(),
          DoctorsList.id: (context) => DoctorsList(),
          DoctorDetails.id: (context) => DoctorDetails(),
          AppointmentDetails.id: (context) => AppointmentDetails(),
        },
      ),
    );
  }
}
