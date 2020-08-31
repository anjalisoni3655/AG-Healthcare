import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/screens/appointments/upcoming_page.dart';
import 'package:healthapp/screens/book_appointments/doctors_list.dart';
import 'package:healthapp/screens/home/accordion.dart';
import 'package:healthapp/screens/home/articles.dart';
import 'package:healthapp/screens/home/videos.dart';
import 'package:healthapp/screens/home/testimonials.dart';

class HomePage extends StatefulWidget {
  @override
  static const id = "home_page";

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF8F8F8),
      child: Container(
        color: Color(0xFFF8F8F8),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _topPoster(),
              _bookAppointmentButton(),
              _textTitle('Upcoming'),
              UpcomingPage(),
              _textTitle('Medical services we offer'),
              MyAccordionWidget(),
              _textTitle('COVID Information Videos'),
              Videos(),
              _textTitle('Articles'),
              Articles(),
              _textTitle('Testimonials'),
              Testimonials(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xFF08134D)),
      ),
    );
  }

  Widget _bookAppointmentButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
      child: RaisedButton(
        onPressed: () {
          //TODO : Implemennt the book appointment here
          print('Book appointment!');
          Navigator.pushNamed(context,DoctorsList.id);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        highlightElevation: 20,
        color: Colors.blue[700],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Book an appointment',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _topPoster() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.white,
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color(0xFF08134D),
                Colors.blue,
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 40, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Dr. Amit Goel',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Endocrinologist \nin Hyderabad',
                        style: TextStyle(
                            height: 1.3,
                            color: Color(0xFF08134D),
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        //TODO : Implemennt the book appointment here
                        print('Book appointment!');
                        Navigator.pushNamed(context, DoctorsList.id);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      highlightElevation: 20,
                      color: Color(0xFF80B7FF),
                      child: Text(
                        'BOOK NOW',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF08134D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image(
                  image: AssetImage('assets/images/doctor.png'),
                  width: 210,
                ),
              )
            ],
          )),
    );
  }
}
