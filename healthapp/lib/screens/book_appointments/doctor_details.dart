import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healthapp/screens/book_appointments/appointment_details.dart';

class DoctorDetails extends StatefulWidget {
  @override
  static const id = "doctor_details";

  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/docdet.png'),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 150, bottom: 100),
                      child: Column(
                        children: [
                          _textTitle(
                              'About', Color(0xFF08134D), 15, FontWeight.w700),
                          _descText(
                              'Dr. M. R. Pujari is highly qualified and highly experienced doctor'
                              ' with 13 years of vast experience. Working as a chief consultant in various'
                              ' dental clinics, cosmetic dentist, root canal specialist, TMJ and oral medicine'
                              ' specialist.',
                              Color(0xFF8F8F8F)),
                          _textTitle('Reviews', Color(0xFF08134D), 15,
                              FontWeight.w700),
                          _reviewContainer(
                              'Rajiv Hussain',
                              'This doctor is so awesome. '
                                  'I go to him for every checkup and I recommend him. '
                                  'One of the best available.',
                              'assets/images/reviewer.png',
                              4,
                              5),
                          _reviewContainer(
                              'Rajiv Hussain',
                              'This doctor is so awesome. '
                                  'I go to him for every checkup and I recommend him. '
                                  'One of the best available.',
                              'assets/images/reviewer.png',
                              4,
                              5),
                          _reviewContainer(
                              'Rajiv Hussain',
                              'This doctor is so awesome. '
                                  'I go to him for every checkup and I recommend him. '
                                  'One of the best available.',
                              'assets/images/reviewer.png',
                              4,
                              5),
                        ],
                      ),
                    ),
                  ],
                ),
                _doctorCard(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: MediaQuery.of(context).size.height * 0.75),
            child: RaisedButton(
              elevation: 10,
              onPressed: () {
                Navigator.pushNamed(context, AppointmentDetails.id);
                print('Redirect to appointment details!');
              },
              color: Color(0xFF408AEB),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  'BOOK NOW',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _doctorCard() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 25),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textTitle('Dr. Amit Goel', Color(0xFF08134D), 29,
                          FontWeight.w700),
                      _coloredBox(Color(0xFFCBFCDD), Color(0xFF30AB6A),
                          'Available Tue, Thu and Sun'),
                      _coloredBox(
                          Color(0xFFE0E4F7), Color(0xFF2748F7), 'Child Sp.'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 10),
                    child: Image(
                      image: AssetImage('assets/icons/doc1.png'),
                      width: 90,
                      height: 90,
                    ),
                  )
                ],
              ),
              _textTitle('BDS, MDS - Oral Medicine and Radiology',
                  Color(0xFF08134D), 14, FontWeight.w600),
              Row(
                children: [
                  _textTitle('4.3', Color(0xFF08134D), 14, FontWeight.w600),
                  RatingBar(
                    itemPadding: EdgeInsets.only(left: 3, right: 10),
                    itemSize: 20,
                    initialRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Color(0xFFE87713),
                    ),
                  ),
                  _descText('(12 reviews)', Color(0xFF8F8F8F)),
                ],
              ),
              _descText('Speaks English | Hindi | Bengali', Color(0xFF8F8F8F)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFF408AEB),
                    size: 20,
                  ),
                  _descText('Room No. 045, Sanaka Hospital,\nDurgapur',
                      Color(0xFF8F8F8F)),
                ],
              ),
              Divider(color: Color(0xFF8F8F8F)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: _textTitle('Charge        Rs 1200', Color(0xFF08134D),
                    18, FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coloredBox(Color backgColor, Color fontColor, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7), color: backgColor),
        child: Text(text,
            style: TextStyle(
                color: fontColor, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _reviewContainer(
      String name, String review, String imgUrl, double rating, int maxRating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(
          children: [
            ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image(
                    image: AssetImage(imgUrl),
                    height: 40,
                    width: 40,
                  )),
              title: _textTitle(name, Color(0xFF08134D), 15, FontWeight.w600),
              subtitle: RatingBar(
                itemSize: 20,
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: maxRating,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Color(0xFFE87713),
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
            _descText(review, Color(0xFF8F8F8F)),
          ],
        ),
      ),
    );
  }

  Widget _descText(String text, Color color) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7)),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: color,
        ),
      ),
    );
  }

  Widget _textTitle(
      String title, Color color, double fontSize, FontWeight fontWeight) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style:
            TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      flexibleSpace: Image(
        image: AssetImage('assets/images/docdet.png'),
        fit: BoxFit.fill,
      ),
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0x8FFFFFFF),
                borderRadius: BorderRadius.circular(7)),
            child: IconButton(
              onPressed: () {
                print('Is this a subtle show-off?');
              },
              icon: FaIcon(
                FontAwesomeIcons.bookmark,
                size: 18,
                color: Color(0xFF007CC2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
