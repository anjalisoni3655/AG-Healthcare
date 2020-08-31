import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:googleapis/bigquery/v2.dart';
import 'package:healthapp/widgets/app_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:healthapp/authentication/user.dart' as globals;
import 'package:toast/toast.dart';
import 'package:healthapp/paymentSuccess.dart';
import 'package:healthapp/paymentFailed.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Color> _textColor = [
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
];
List<Color> _bodyColor = [
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
];

List<Color> _textColorMorningEvening = [Color(0xFFFFFFFF), Color(0xFF08134D)];
List<Color> _bodyColorMorningEvening = [Color(0xFF408AEB), Color(0xFFFFFFFF)];

List<Color> _textColorTimeTable = [
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F)
];
List<Color> _bodyColorTimeTable = [
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF)
];

bool anyColorSelected = false;
DateTime selectedDate = null;
String visitType, visitTime = 'Morning', visitDuration;

int _compIndex(int index) {
  if (index % 2 == 1)
    return index - 1;
  else
    return index + 1;
}

class AppointmentDetails extends StatefulWidget {
  @override
  static const id = "appointment_details";

  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

String type;
String gender, dob, blood, marital, address, name, email;
String height, weight, photo;

String id;
SharedPreferences prefs;

class _AppointmentDetailsState extends State<AppointmentDetails> {
  Razorpay razorpay;

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? globals.user.name;
    email = prefs.getString('email') ?? globals.user.email;
    photo = prefs.getString('photo') ?? globals.user.photo;
    gender = prefs.getString('gender') ?? globals.user.gender;
    dob = prefs.getString('dob') ?? globals.user.dob;
    blood = prefs.getString('blood') ?? globals.user.blood;
    height = prefs.getString('height') ?? globals.user.height;
    weight = prefs.getString('dob') ?? globals.user.weight;
    marital = prefs.getString('marital') ?? globals.user.marital;
    address = prefs.getString('address') ?? globals.user.address;

    email = email.split('@')[0];

    // Force refresh input
    setState(() {});
  }

  @override
  void initState() {
    readLocal();
    super.initState();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  Map<String, String> notes = new Map();

  void openCheckout() {
    String date = selectedDate.toString();
    date = date.substring(0, 10);
    globals.user.date = date;
    globals.user.visitDuration = visitDuration;

    globals.user.visitTime = visitTime;

    globals.user.visitType = visitType;

    var options = {
      "key": "rzp_test_7ygVzTh2b1Y9df",
      "amount": (globals.user.cost) * 100,
      "name": "Dr Amit Goel Clinic",

      //                         visitTime: visitTime,
      //                         visitType: visitType,
      //                         visitDuration: visitDuration,

      // 'timeout': 60, // in seconds
//TODO:send these details
      "notes": {
        //  "Age":"20",
        "Name": name,
        "Gender": gender,
        //TODO: add a field why is he visiting when he is booking the payment
        "Reason to visit": "Cough and Cold",
        //TODO: add this variable

        "First time/Follow up": "First Time",

        "Date of Birth": dob,
        "Blood Group": blood,
        "Height": height,
        "Weight": weight,
        "Marital Status": marital,
        "Home Address": address,
      },
      //"theme": "#FFFFFF",
      "description": "$visitType, $date, $visitDuration($visitTime)",
      "image":
          "https://dramitendo.com/wp-content/uploads/2020/07/Dr-Amit-Goel.png",
      "prefill": {
        "contact": "",
        "email": "",
      },
      "currency": "INR",
      "payment_capture": 1,
      "external": {
        "wallets": ["paytm", "phonepe", "gpay"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print('paymentid');
    print(response.paymentId);
    globals.user.paymentId = response.paymentId;
    print("Payment success");
    Toast.show("Payment success", context);
    globals.getPatientofGivenBookingId(response.paymentId);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SuccessPage(
          response: response,
        ),
      ),
      (Route<dynamic> route) => false,
    );
    razorpay.clear();
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print("Payment error");
    Toast.show("Payment error", context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FailedPage(
          response: response,
        ),
      ),
      (Route<dynamic> route) => false,
    );
    razorpay.clear();
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print("External Wallet");
    Toast.show("External Wallet", context);
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    // PaymentSuccessResponse response;

    print(globals.user.cost);
    String name, expYears, fields, costs;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      name = arguments['name'];
      expYears = arguments['expYears'];
      fields = arguments['fields'];
      costs = arguments['costs'];
    }
    return Scaffold(
      appBar: customAppBar('Appointment', context),
      body: Material(
        color: Color(0xFFF8F8F8),
        child: Container(
          color: Color(0xFFF8F8F8),
          height: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child:
                                _getText('Select type', 15, Color(0xFF8F8F8F)),
                          ),
                          Row(
                            children: [
                              _customButton('Online', 18, 0, 15),
                              Padding(
                                padding: EdgeInsets.all(15),
                              ),
                              _customButton('Clinic Visit', 18, 1, 15),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (_bodyColor[1] == Color(0xFFDFE9F7)),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: _getText(
                                  'Are you consulting this doctor first time?',
                                  15,
                                  Color(0xFF8F8F8F)),
                            ),
                            Row(
                              children: [
                                _customButton('First time', 18, 2, 15),
                                Padding(
                                  padding: EdgeInsets.all(15),
                                ),
                                _customButton('Follow up', 18, 3, 15),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (_bodyColor[0] == Color(0xFFDFE9F7) ||
                          (_bodyColor[1] == Color(0xFFDFE9F7) &&
                              (_bodyColor[2] == Color(0xFFDFE9F7) ||
                                  _bodyColor[3] == Color(0xFFDFE9F7)))),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: _getText('Date', 15, Color(0xFF8F8F8F)),
                            ),
                            _getDateTime(context),
                            Visibility(
                              visible: selectedDate != null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child:
                                        _getText('Time', 15, Color(0xFF8F8F8F)),
                                  ),
                                  _switchMorningEvening(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: _timeTable(),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 100)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: anyColorSelected,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.75),
                        child: RaisedButton(
                          elevation: 10,
                          padding: EdgeInsets.all(15),
                          color: Color(0xFF408AEB),
                          child: _getText('Confirm', 16, Colors.white),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () async {
                            await globals.uploadBookingDetails(
                              doctorName: name,
                              years: expYears,
                              field: fields,
                              cost: costs,
                              selectedDate: selectedDate,
                              visitTime: visitTime,
                              visitType: visitType,
                              visitDuration: visitDuration,
                              email: globals.user.email,
                              id: globals.user.id,
                              photo: globals.user.photo,
                              name: globals.user.name,
                            );
                            print('done');
                            globals.getAllPatientDetail();
                            openCheckout();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeTable() {
    return Container(
      child: Column(
        children: [
          for (int i = 1; i <= 6; i++)
            Row(
              children: [
                _buttonTimeTable(i * 3 - 3, '9:00 - 9:15'),
                Padding(padding: EdgeInsets.all(5)),
                _buttonTimeTable(i * 3 - 2, '9:00 - 9:15'),
                Padding(padding: EdgeInsets.all(5)),
                _buttonTimeTable(i * 3 - 1, '9:00 - 9:15'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buttonTimeTable(int index, String text) {
    return Expanded(
      child: RaisedButton(
        elevation: 0,
        padding: EdgeInsets.all(10),
        color: _bodyColorTimeTable[index],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: _getText(text, 15, _textColorTimeTable[index]),
        onPressed: () {
          setState(() {
            anyColorSelected = true;
            if (_bodyColorTimeTable[index] == Color(0xFFFFFFFF)) {
              visitDuration = '9:00-9:15';
              _bodyColorTimeTable[index] = Color(0xFFDFE9F7);
              _textColorTimeTable[index] = Color(0xFF408AEB);
              for (int i = 0; i < 18; i++) {
                if (i != index) {
                  _bodyColorTimeTable[i] = Color(0xFFFFFFFF);
                  _textColorTimeTable[i] = Color(0xFF8F8F8F);
                }
              }
            } else {
              anyColorSelected = false;
              _bodyColorTimeTable[index] = Color(0xFFFFFFFF);
              _textColorTimeTable[index] = Color(0xFF8F8F8F);
            }
          });
        },
      ),
    );
  }

  Widget _switchMorningEvening() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(23)),
      child: Row(
        children: [
          _buttonsMorningEvening('Morning', 0),
          _buttonsMorningEvening('Evening', 1),
        ],
      ),
    );
  }

  Widget _buttonsMorningEvening(String text, int index) {
    return Expanded(
      child: RaisedButton(
        elevation: 0,
        padding: EdgeInsets.all(10),
        color: _bodyColorMorningEvening[index],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Image(
                image: (index == 0)
                    ? AssetImage(
                        'assets/icons/sun.png',
                      )
                    : AssetImage('assets/icons/moon.png'),
                width: 20,
                height: 20,
              ),
            ),
            _getText(text, 15, _textColorMorningEvening[index]),
          ],
        ),
        onPressed: () {
          setState(() {
            if (_bodyColorMorningEvening[index] == Color(0xFFFFFFFF)) {
              visitTime = (index == 0) ? 'Morning' : 'Evening';
              _bodyColorMorningEvening[index] = Color(0xFF408AEB);
              _textColorMorningEvening[index] = Color(0xFFFFFFFF);
              _bodyColorMorningEvening[_compIndex(index)] = Color(0xFFFFFFFF);
              _textColorMorningEvening[_compIndex(index)] = Color(0xFF08134D);
            }
          });
        },
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: GoogleFonts.nunitoTextTheme(),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF408AEB),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget _getDateTime(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: (selectedDate == null) ? Colors.white : Color(0xFFDFE9F7),
        ),
        child: Row(
          children: [
            (selectedDate == null)
                ? _getText('yyyy-mm-dd', 15, Color(0xFF8F8F8F))
                : _getText('${selectedDate.toLocal()}'.split(' ')[0], 15,
                    Color(0xFF408AEB)),
            Spacer(),
            Icon(Icons.calendar_today,
                color: (selectedDate == null)
                    ? Color(0xFF8F8F8F)
                    : Color(0xFF408AEB),
                size: 20),
          ],
        ),
      ),
    );
  }

  Widget _customButton(String text, double tSize, int index, double padding) {
    return Expanded(
      child: RaisedButton(
        elevation: 0,
        padding: EdgeInsets.all(padding),
        color: _bodyColor[index],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: _getText(text, tSize, _textColor[index]),
        onPressed: () {
          setState(() {
            if (_bodyColor[index] == Color(0xFFFFFFFF)) {
              selectedDate = null;
              anyColorSelected = false;
              _bodyColor[_compIndex(index)] = _bodyColor[index];
              _textColor[_compIndex(index)] = _textColor[index];
              _bodyColor[index] = Color(0xFFDFE9F7);
              _textColor[index] = Color(0xFF408AEB);
              if (index == 0 || index == 1) {
                visitType = (index == 0) ? 'Online' : 'Clinic';
                _bodyColor[2] = _bodyColor[3] = Color(0xFFFFFFFF);
                _textColor[2] = _textColor[3] = Color(0xFF8F8F8F);
              }
            } else {
              selectedDate = null;
              anyColorSelected = false;
              _bodyColor[index] = Color(0xFFFFFFFF);
              _textColor[index] = Color(0xFF8F8F8F);
            }
          });
        },
      ),
    );
  }

  Widget _getText(String text, double size, Color color) {
    return Text(
      text,
      style:
          TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w600),
    );
  }
}
