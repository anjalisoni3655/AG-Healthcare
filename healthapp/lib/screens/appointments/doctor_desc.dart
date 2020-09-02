import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healthapp/authentication/user.dart' as globals;

class DoctorDesc extends StatefulWidget {
  @override
  static const id = "doctor_desc";

  _DoctorDescState createState() => _DoctorDescState();
}

class _DoctorDescState extends State<DoctorDesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Image(
                  image: AssetImage('assets/images/docdet.png'),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: 200, bottom: 100),
                  child: Column(
                    children: [
                      _textTitle(
                          'About', Color(0xFF08134D), 15, FontWeight.w700),
                      _descText(
                          'Dr Amit Goel has a decade of experience in the field of medicine with '
                          'an experience as an Endocrinologist for over 4 years. Dr Amit’s published '
                          'articles are one of the best in the world for research on prevention and early '
                          'detection of diabetic neuropathy.',
                          Color(0xFF8F8F8F)),
                    ],
                  ),
                ),
              ],
            ),
            _doctorCard(),
          ],
        ),
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
                          'Available : Mon - Sat'),
                      _coloredBox(Color(0xFFE0E4F7), Color(0xFF2748F7),
                          'Endocrinologist'),
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
              _textTitle('DM – Endocrinology, MD – General Medicine',
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
              _descText(
                  'Speaks Telugu | Hindi | English | Kannada | Bengali | Marathi.',
                  Color(0xFF8F8F8F)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFF408AEB),
                    size: 20,
                  ),
                  Flexible(
                    child: _descText(
                        'Plot no. 9B, Vikrampuri Colony, '
                        'Secunderabad, Telangana',
                        Color(0xFF8F8F8F)),
                  ),
                ],
              ),
              Divider(color: Color(0xFF8F8F8F)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: _textTitle('Charge        Rs 400', Color(0xFF08134D), 18,
                    FontWeight.w700),
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
    );
  }
}
