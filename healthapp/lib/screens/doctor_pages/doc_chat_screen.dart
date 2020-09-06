import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/screens/doctor_pages/doc_chat.dart';
import 'package:healthapp/components/const.dart';
import 'package:healthapp/screens/edit_profile.dart';
import 'package:healthapp/utils/settings.dart';
import 'package:healthapp/widgets/loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:healthapp/main.dart';
import 'package:intl/intl.dart';

String visitTime = 'Upcoming';
var mapDates = new Map();

int _compIndex(int index) {
  if (index % 2 == 1)
    return index - 1;
  else
    return index + 1;
}

List<Color> _textColorMorningEvening = [Color(0xFFFFFFFF), Color(0xFF08134D)];
List<Color> _bodyColorMorningEvening = [Color(0xFF408AEB), Color(0xFFFFFFFF)];

class DocChatScreen extends StatefulWidget {
  final String currentUserId;
  static const id = "doc_chat_screen";
  DocChatScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => DocChatScreenState(currentUserId: currentUserId);
}

class DocChatScreenState extends State<DocChatScreen> {
  DocChatScreenState({Key key, @required this.currentUserId});

  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('user')
          .document(currentUserId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF8F8F8),
      child: SafeArea(
        child: WillPopScope(
          child: Stack(
            children: <Widget>[
              // List
              Container(
                child: Column(
                  children: [
                    _switchMorningEvening(),
                    Expanded(
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('booking_details')
                            .orderBy('selectedDate', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          print(snapshot);

                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xfff5a623)),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              itemBuilder: (context, index) => buildItem(
                                  context,
                                  snapshot.data.documents[index],
                                  index,
                                  snapshot.data.documents),
                              itemCount: snapshot.data.documents.length,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Loading
              Positioned(
                child: isLoading ? const Loading() : Container(),
              )
            ],
          ),
          //  onWillPop:,
        ),
      ),
    );
  }

  Widget buildItem(
      BuildContext context, DocumentSnapshot document, int index, documents) {
    if (visitTime == 'Upcoming') {
      if (!document.data['selectedDate'].toDate().isBefore(DateTime.now())) {
        return buildInteriorItem(context, document, index, documents);
      } else
        return Container();
    } else {
      if (document.data['selectedDate'].toDate().isBefore(DateTime.now())) {
        return buildInteriorItem(context, document, index, documents);
      } else
        return Container();
    }
  }

  Widget buildInteriorItem(
      BuildContext context, DocumentSnapshot document, int index, documents) {
    String time = document.data['visitDuration'];
    if (document['visitTime'] == 'Morning')
      time += ' AM';
    else
      time += ' PM';
    Timestamp visitDate = document.data['selectedDate'];
    String date =
        dateTimeConverter(visitDate.toDate().toString().split(' ')[0]);
    String year = (date.split(',')[1].substring(1, 5));
    date = date.split(',')[0];
    String month = date.split(' ')[1].substring(0, 3);

    bool ok = true;
    for (int i = index - 1; i >= 0; i--) {
      Timestamp visitDate1 = documents[i].data['selectedDate'];
      String date1 =
          dateTimeConverter(visitDate1.toDate().toString().split(' ')[0]);
      String year1 = (date1.split(',')[1].substring(1, 5));
      date1 = date1.split(',')[0];
      String month1 = date1.split(' ')[1].substring(0, 3);
      if (month == month1 && year == year1) {
        ok = false;
        break;
      }
    }

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DocChat(
                      peerId: document['id'],
                      peerAvatar: document['photo'],
                      peerName: document['name'],
                      bookingInfo: document,
                    )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (ok == true)
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _getText(month + " " + year, 15, Color(0xFF8F8F8F)),
              )
              : Container(),
          _appointmentsTab(document['photo'], document['name'], date, time),
        ],
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

  Widget _switchMorningEvening() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(23)),
        child: Row(
          children: [
            _buttonsMorningEvening('Upcoming', 0),
            _buttonsMorningEvening('Past', 1),
          ],
        ),
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
            _getText(text, 15, _textColorMorningEvening[index]),
          ],
        ),
        onPressed: () {
          setState(() {
            if (_bodyColorMorningEvening[index] == Color(0xFFFFFFFF)) {
              visitTime = (index == 0) ? 'Upcoming' : 'Past';
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

  Widget _appointmentsTab(
      String imgUrl, String name, String date, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7), color: Colors.white),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: _imageIcon(imgUrl),
          title: _doctorName(name),
          subtitle: _upcomingSubtitle(time),
          trailing: _upcomingDate(
              date.split(" ")[0], date.split(" ")[1].substring(0, 3)),
        ),
      ),
    );
  }

  Widget _imageIcon(String imgUrl) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image(image: NetworkImage(imgUrl)));
  }

  Widget _doctorName(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        name,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF08134D),
            fontSize: 18),
      ),
    );
  }

  Widget _upcomingDate(String day, String month) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 4),
      decoration: BoxDecoration(
          color: Colors.lightBlue[200], borderRadius: BorderRadius.circular(7)),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: Color(0xFF262626),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            month,
            style: TextStyle(
              color: Color(0xFF262626),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _upcomingSubtitle(String time) {
    return Text(
      time,
      style: TextStyle(
          fontWeight: FontWeight.w500, color: Color(0xFF408AEB), fontSize: 15),
    );
  }

  Widget _ongoingOrCompletedSubtitle(String type, String message) {
    var _colorForSubtitle = Color(0xFFF3AB65);
    if (type == 'Completed') _colorForSubtitle = Color(0xFF30AB6A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: _colorForSubtitle, shape: BoxShape.circle),
                height: 9,
                width: 9,
              ),
            ),
            Text(
              type,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _colorForSubtitle,
                  fontSize: 15),
            ),
          ],
        ),
        Text(
          message,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF8F8F8F),
              fontSize: 15),
        ),
      ],
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
