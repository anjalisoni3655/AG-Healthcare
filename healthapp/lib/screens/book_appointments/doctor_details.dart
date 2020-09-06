import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healthapp/screens/book_appointments/appointment_details.dart';
import 'package:healthapp/authentication/user.dart' as globals;

import 'package:cloud_firestore/cloud_firestore.dart';

String validateAge(String rate) {
  Pattern pattern = r'[.,|_]';
  RegExp regex = RegExp(pattern);
  if (rate.isEmpty) {
    return 'This field cannot be empty';
  } else {
    if (regex.hasMatch(rate)) {
      return 'Please enter a valid rating';
    } else {
      int num = int.parse(rate);
      if (num > 0 && num < 6) {
        return null;
      } else
        return 'Please enter a valid rating';
    }
  }
}

String photourl,
    about,
    address,
    doctorName,
    languages,
    cost,
    designation,
    available,
    courses,
    review;
int rate = 4;
void getDoctorDetails() async {
  Firestore.instance
      .collection("doctor")
      .document("5lXYnBBrxXvgU0dpZGId")
      .get()
      .then((value) {
    courses = value.data['courses'] ?? "COURSES";
    photourl = value.data['photourl'] ??
        "https://dramitendo.com/wp-content/uploads/2020/07/Dr-Amit-Goel.png";
    about = value.data['about'] ?? "ABOUT";
    doctorName = value.data['name'] ?? "NAME";
    address = value.data['address'] ?? "ADDRESS";
    available = value.data['available'] ?? "AVAILABLE";
    designation = value.data['designation'] ?? "DESIGNATION";
    languages = value.data['languages'] ?? "LANGYAGES";
    cost = value.data['cost'] ?? "COST";
  });
}

List<String> photos = [];
List<int> ratings = [];
List<String> names = [];
List<String> comments = [];
int len = 0;
bool called = false;
void getReviews() async {
  //TODO: add these snapshots in the review section
  Firestore.instance.collection("review").getDocuments().then((querySnapshot) {
    querySnapshot.documents.forEach((result) {
      print(result.data);
      photos.add(result.data['photo']);
      names.add(result.data['name']);
      ratings.add(result.data['rate']);
      comments.add(result.data['comment']);
      // len++;
    });
  });
}

class DoctorDetails extends StatefulWidget {
  @override
  static const id = "doctor_details";

  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextStyle textStyle2 = TextStyle(
      color: Color(0xFF606060), fontSize: 15, fontWeight: FontWeight.w600);
  InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
  );

  Widget build(BuildContext context) {
    getDoctorDetails();
    if (called == false) {
      setState(() {
        getReviews();
      });

      called = true;
    }
    /*  print(doctorName);
    print(available);
    print(designation);
    print(languages);
    print(about);
    print(address);
    print(cost);
    print(photourl);
    print(courses); */
    print(photos);
    print(ratings);
    print(names);
    print(comments);

    String name, expYears, fields, costs;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      name = arguments['name'];
      expYears = arguments['expYears'];
      fields = arguments['fields'];
      costs = arguments['costs'];
      print(name);
    }

    globals.user.cost = int.parse(costs.substring(3));

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
                          // _textTitle('Reviews', Color(0xFF08134D), 15,
                          //     FontWeight.w700),
                          // TODO : REVIEW PART NEEDS TO BE MADE BETTER | ANJALI IS VERY ANGRY AFTER MAKIN' A MESS!
                          // Form(
                          //   key: _formKey,
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       Container(
                          //         padding: EdgeInsets.symmetric(vertical: 5),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.symmetric(
                          //                   vertical: 10),
                          //               child: Text('How was your experience'),
                          //             ),
                          //             TextFormField(
                          //                 decoration: inputDecoration,
                          //                 cursorColor: Color(0xFF8F8F8F),
                          //                 cursorRadius: Radius.circular(10),
                          //                 cursorWidth: 0.5,
                          //                 style: textStyle2,
                          //                 //  validator: validateName,
                          //                 onSaved: (String value) {
                          //                   review = value;
                          //                 }),
                          //             Padding(
                          //               padding: const EdgeInsets.symmetric(
                          //                   vertical: 10),
                          //               child: Text('Give your rating(1-5)'),
                          //             ),
                          //             TextFormField(
                          //                 decoration: inputDecoration,
                          //                 cursorColor: Color(0xFF8F8F8F),
                          //                 cursorRadius: Radius.circular(10),
                          //                 cursorWidth: 0.5,
                          //                 style: textStyle2,
                          //                 keyboardType: TextInputType.number,
                          //                 validator: validateAge,
                          //                 onSaved: (String value) {
                          //                   rate = int.tryParse(value);
                          //                 }),
                          //           ],
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.all(10),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // RaisedButton(
                          //   elevation: 5,
                          //   onPressed: () async {
                          //     // if (!_formKey.currentState.validate()) {
                          //     //   return;
                          //     // }
                          //     _formKey.currentState.save();
                          //     print("Submit your review");
                          //     print(review);
                          //     print(rate);
                          //     await globals.uploadReviews(
                          //         rate: rate, comment: review);
                          //   },
                          //   color: Color(0xFF408AEB),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(7)),
                          //   child: Container(
                          //     width: double.infinity,
                          //     alignment: Alignment.center,
                          //     height: 50,
                          //     child: Text(
                          //       'Submit your review',
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.white,
                          //           fontSize: 16),
                          //     ),
                          //   ),
                          // ),
                          // for (var i = 0; i < names.length; i++)
                          //   _reviewContainer(names[i], comments[i], photos[i],
                          //       ratings[i].toDouble(), 5),
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
                top: MediaQuery.of(context).size.height * 0.78),
            child: RaisedButton(
              elevation: 10,
              onPressed: () {
                //  print(name);
                Navigator.pushNamed(context, AppointmentDetails.id, arguments: {
                  'name': name,
                  'expYears': expYears,
                  'fields': fields,
                  'costs': costs,
                });
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
                    child: _descText('address', Color(0xFF8F8F8F)),
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
                    image: NetworkImage(imgUrl),
                    height: 40.0,
                    width: 40.0,
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
