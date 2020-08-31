import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/screens/chat.dart';
import 'package:healthapp/components/const.dart';
import 'package:healthapp/screens/edit_profile.dart';
import 'package:healthapp/widgets/loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:healthapp/main.dart';
import 'package:intl/intl.dart';

import 'appointments/upcoming_page.dart';

const List<String> doc_images = ['doc1', 'doc2', 'doc3', 'doc4'];
const List<String> doc_names = [
  'Dr.Amit Goel',
  'Dr. Ushita Das',
  'Dr. David Hussen',
  'Dr. William Lin',
];
const List<String> type = ['Future', 'Future', 'Completed', 'Ongoing'];
const List<String> visitType = ['Clinic Visit', 'Online Visit', '', ''];
const List<String> date = ['01 Jun', '04 Jun', '', ''];
const List<String> time = ['6:30 PM', '6:45PM', '', ''];
const String message = 'Last message: Thank you do ...';

class ChatScreen extends StatefulWidget {
  @override
  static const id = "chat_screen";
  final String currentUserId;

  ChatScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => ChatScreenState(currentUserId: currentUserId);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.currentUserId});

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
    return SafeArea(
      child: Material(
        color: Color(0xFFF8F8F8),
        child: WillPopScope(
          child: Stack(
            children: <Widget>[
              // List
              Container(
                child: StreamBuilder(
                  stream: Firestore.instance.collection('user').snapshots(),
                  builder: (context, snapshot) {
                    print(snapshot);

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: UpcomingPage(),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemBuilder: (context, index) =>
                                  buildItem(context, snapshot.data.documents[index]),
                              itemCount: snapshot.data.documents.length,
                            ),
                          ),
                        ],
                      );
                    }
                  },
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

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          peerId: document.documentID,
                          peerAvatar: document['photoUrl'],
                        )));
          },
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7), color: Colors.white),
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: _imageIcon(document['photoUrl']),
              title: _doctorName('${document['name']}'),
              subtitle: _ongoingOrCompletedSubtitle(
                'Ongoing',
                'I have taken medicines ... ',
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _appointmentsTab(String imgUrl, String name, String type,
      String visitType, String time, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7), color: Colors.white),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: _imageIcon(imgUrl),
          title: _doctorName(name),
          subtitle: _upcomingSubtitle(visitType, time),
          trailing: _upcomingDate(date.split(" ")[0], date.split(" ")[1]),
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

  Widget _upcomingSubtitle(String type, String time) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            type,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF08134D),
                fontSize: 15),
          ),
        ),
        Text(
          time,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF408AEB),
              fontSize: 15),
        ),
      ],
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
