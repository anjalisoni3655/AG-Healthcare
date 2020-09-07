import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/chat/v1.dart';
import 'package:healthapp/screens/home/home_page.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:healthapp/utils/settings.dart';
import 'package:healthapp/widgets/app_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/authentication/user.dart' as globals;

class SuccessPage extends StatelessWidget {
  final PaymentSuccessResponse response;

  SuccessPage({
    @required this.response,
  });

  TextStyle _textStyle1 = TextStyle(
      color: Color(0xFF8F8F8F),
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.5);
  TextStyle _textStyle2 = TextStyle(
      color: Color(0xFF08134D),
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.5);
  TextStyle _textStyle3 = TextStyle(
      color: Color(0xFF08134D),
      fontSize: 15,
      fontWeight: FontWeight.bold,
      height: 1.5);
  String dateCurrent = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Payment Confirmation',
          style: GoogleFonts.varelaRound(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF262626),
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, HomeScreen.id);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue[700],
            )),
      ),
      body: SafeArea(
        child: Material(
          color: Color(0xFFF8F8F8),
          child: SingleChildScrollView(
            child: Container(
              color: Color(0xFFF8F8F8),
              margin: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF46CC85),
                        borderRadius: BorderRadius.circular(7)),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          'Payment Successful!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Text(
                          'Amount Paid',
                          style: _textStyle3,
                        ),
                        Spacer(),
                        Text(
                          'Rs ' + (globals.user.cost).toString(),
                          style: _textStyle3,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7)),
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'To Amit Goel Clinic',
                                  style: _textStyle2,
                                ),
                                Text(
                                  'From SBI Bank Accounts',
                                  style: _textStyle1,
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.monetization_on,
                              size: 30,
                              color: Color(0xFF408AEB),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Row(
                          children: [
                            Text(
                              'Booking ID',
                              style: _textStyle1,
                            ),
                            Spacer(),
                            Text(
                              response.paymentId,
                              style: _textStyle2,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Booked On',
                              style: _textStyle1,
                            ),
                            Spacer(),
                            Text(
                              dateCurrent.substring(0, 16),
                              style: _textStyle2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Text(
                          'Appointment Details',
                          style: _textStyle3,
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color(0xFFDFE9F7),
                              borderRadius: BorderRadius.circular(7)),
                          child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.refresh,
                              color: Color(0xFF007CC2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7)),
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Doctor Name',
                              style: _textStyle1,
                            ),
                            Spacer(),
                            Text(
                              'Dr. Amit Goel',
                              style: _textStyle2,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Date',
                              style: _textStyle1,
                            ),
                            Spacer(),
                            Text(
                              dateTimeConverter(globals.user.date),
                              style: _textStyle2,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Time',
                              style: _textStyle1,
                            ),
                            Spacer(),
                            Text(
                              globals.user.visitDuration +
                                  ' (' +
                                  globals.user.visitTime +
                                  ')',
                              style: _textStyle2,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Type of visit',
                              style: _textStyle1,
                            ),
                            Spacer(),
                            Text(
                              globals.user.visitType,
                              style: _textStyle2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.12),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            color: Color(0xFF408AEB),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            onPressed: () async {
                              // final _id = Firestore.instance
                              //     .collection('booking_details')
                              //     .document()
                              //     .documentID;
                              await Firestore.instance
                                  .collection("booking_details")
                                  .document(globals.user.id)
                                  .updateData({
                                "paymentId": response.paymentId,
                                "phone": globals.user.phone,
                              }).then((_) {
                                print("success!");
                              });

                              Navigator.pushNamed(context, HomeScreen.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Done',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
