import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthapp/authentication/user.dart' as globals;
import 'package:healthapp/utils/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

void getPrescriptionByPatient() {
  Firestore.instance
      .collection("messages")
      .getDocuments()
      .then((querySnapshot) {
    querySnapshot.documents.forEach((result) {
      Firestore.instance
          .collection("messages")
          .document(result.documentID)
          .collection(result.documentID)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          print('presCRIPTION');
          print(result.data);
        });
      });
    });
  });
}

class UserDesc extends StatefulWidget {
  @override
  static const id = "user_desc";

  _UserDescState createState() => _UserDescState();
  final DocumentSnapshot bookingInfo;

  UserDesc({Key key, @required this.bookingInfo}) : super(key: key);
}

class _UserDescState extends State<UserDesc> {
  @override
  Widget build(BuildContext context) {
    print('documents');
    getPrescriptionByPatient();

    DocumentSnapshot bookingInfo = widget.bookingInfo;
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
                      left: 20, right: 20, top: 40, bottom: 100),
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('user_details')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xfff5a623)),
                            ),
                          );
                        } else {
                          //  print(snapshot.data.documents[3].data);
                          String name,
                              age,
                              phone,
                              gender,
                              height,
                              weight,
                              blood,
                              marital;
                          for (int i = 0;
                              i < snapshot.data.documents.length;
                              i++) {
                            if (snapshot.data.documents[i].documentID ==
                                bookingInfo.data['id']) {
                              name = snapshot.data.documents[i].data['name'];
                              age = snapshot.data.documents[i].data['dob'];
                              phone = snapshot.data.documents[i].data['phone'];
                              gender =
                                  snapshot.data.documents[i].data['gender'];
                              height = snapshot.data.documents[i].data['height']
                                  .toString();
                              weight = snapshot.data.documents[i].data['weight']
                                  .toString();
                              blood = snapshot.data.documents[i].data['blood'];
                              marital =
                                  snapshot.data.documents[i].data['marital'];
                              int years = int.parse(
                                      DateTime.now().toString().split('-')[0]) -
                                  int.parse(age.split('-')[0]);
                              age = years.toString();
                              break;
                            }
                          }

                          return Column(
                            children: [
                              _textTitle('Patient Details', Color(0xFF08134D),
                                  15, FontWeight.w700),
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'PatientName',
                                          style: TextStyle(
                                            height: 1.5,
                                            color: Color(0xFF8F8F8F),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          name,
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF08134D),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'PatientMobileNo',
                                          style: TextStyle(
                                            height: 1.5,
                                            color: Color(0xFF8F8F8F),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          phone?? '1234567890',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF08134D),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Age',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF8F8F8F),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Text(
                                          age + ' years',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF08134D),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Gender',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF8F8F8F),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Text(
                                          gender,
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF08134D),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Height',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF8F8F8F),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Text(
                                          height + ' cm',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF08134D),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Weight',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF8F8F8F),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Text(
                                          weight + ' kg',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF08134D),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Blood Group',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF8F8F8F),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Text(
                                          blood,
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF08134D),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Marital Status',
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF8F8F8F),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Text(
                                          marital,
                                          style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF08134D),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
              ],
            ),
            _userCard(),
          ],
        ),
      ),
    );
  }

  Widget _userCard() {
    DocumentSnapshot bookingInfo = widget.bookingInfo;
    String time = bookingInfo.data['visitDuration'];
    time = time.split('-')[0] + ' - ' + time.split('-')[1];
    if (bookingInfo.data['visitTime'] == 'Morning')
      time += ' AM';
    else
      time += ' PM';
    Timestamp visitDate = bookingInfo.data['selectedDate'];
    String date =
        dateTimeConverter(visitDate.toDate().toString().split(' ')[0]);
    // print(date);
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 50),
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
                      _textTitle(bookingInfo.data['name'], Color(0xFF08134D),
                          24, FontWeight.w700),
                      (bookingInfo['selectedDate']
                              .toDate()
                              .isBefore(DateTime.now()))
                          ? _coloredBox(
                              Colors.orange[100], Color(0xFFE87713), 'Ongoing')
                          : _coloredBox(
                              Color(0xFFCBFCDD), Color(0xFF30AB6A), 'Upcoming'),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: NetworkImage(bookingInfo.data['photo']),
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: FaIcon(
                        FontAwesomeIcons.calendarAlt,
                        color: Color(0xFF408AEB),
                        size: 18,
                      ),
                    ),
                    Text(date,
                        style: TextStyle(
                            color: Color(0xFF08134D),
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: FaIcon(
                        FontAwesomeIcons.solidClock,
                        color: Color(0xFF408AEB),
                        size: 18,
                      ),
                    ),
                    Text(time,
                        style: TextStyle(
                            color: Color(0xFF08134D),
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              )
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
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
          fontWeight: FontWeight.w600,
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
      actions: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xFFDFE9F7), borderRadius: BorderRadius.circular(7)),
          child: GestureDetector(
            onTap: () async {
              //TODO : delete the respective document
              var firebaseUser = await FirebaseAuth.instance.currentUser();
              Firestore.instance
                  .collection("booking_details")
                  .document(firebaseUser.uid)
                  .delete()
                  .then((_) {
                print("success!");
                //TODO: MENTION the respective patients email here, so that the doctor can give a reason to the patient why ihe is cancelling
                _launchURL('anjalisoni3655@gmail.com', 'appointment cancelled',
                    'your appointment has been cancelled');
              });
            },
            child: Icon(
              Icons.delete,
              size: 24,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
