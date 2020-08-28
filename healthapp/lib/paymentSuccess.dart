import 'package:flutter/material.dart';
import 'package:healthapp/screens/home/home_page.dart';
import 'package:healthapp/screens/home_screen.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/authentication/user.dart' as globals;

class SuccessPage extends StatelessWidget {
  final PaymentSuccessResponse response;
  SuccessPage({
    @required this.response,
  });
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Success"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  final _id = Firestore.instance.collection('booking_details').document().documentID;
                  await Firestore.instance
                      .collection("booking_details")
                      .document(globals.user.email)
                      .updateData({
                    "paymentId": response.paymentId,
                  }).then((_) {
                    print("success!");
                  });

                  Navigator.pushNamed(context, HomeScreen.id);
                },
                child: Icon(
                  Icons.home,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Center(
        child: Container(
          child: Text(
            "Your payment is successful and the response is\n OrderId: ${response.orderId}\nPaymentId: ${response.paymentId}\nSignature: ${response.signature}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}