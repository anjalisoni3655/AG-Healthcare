import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String testimonial =
    'Its indeed a pleasure and my sincere thanks to the doctor for controlling my sugar while I had visited almost all doctors. '
    'But in my first visit to the doctor I saw a dedicated approach and I was explained that my technique of taking insulin was not correct and a few modifications of the dose.';
String signature = 'Mr. Ragi Reddy (Entrepreneur)';

class Testimonials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (var i = 0; i < 6; i++)
            _testimonialContainer(testimonial, signature),
        ],
      ),
    );
  }
}

Widget _testimonialContainer(String t, String s) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, bottom: 10),
    child: Container(
      width: 360,
      child: RaisedButton(
        onPressed: () {
          print('Pressed!');
        },
        highlightElevation: 15,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(
              FontAwesomeIcons.quoteLeft,
              color: Colors.blue[700],
            ),
            Container(
                padding: EdgeInsets.all(3),
                child: Text(
                  t,
                  style: TextStyle(color: Color(0xFF8F8F8F)),
                )),
            Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                '-' + s,
                style: TextStyle(color: Color(0xFF08134D)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
