import 'package:flutter/material.dart';
import 'package:healthapp/screens/home/home_page.dart';
import 'package:healthapp/screens/home_screen.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

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
            "Your payment is successful and the response is\n OrderId: ${response.orderId}\nPaymentId: ${response.paymentId}\nSignature: ${response.signature}",
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
