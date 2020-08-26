import 'package:flutter/material.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:healthapp/screens/home_screen.dart';

class FailedPage extends StatelessWidget {
  final PaymentFailureResponse response;
  FailedPage({
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
                onTap: () {
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
            "Your payment is Failed and the response is\n Code: ${response.code}\nMessage: ${response.message}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}