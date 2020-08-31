import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/authentication/google_login.dart';
import 'package:healthapp/authentication/user.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthapp/utils/settings.dart';
import 'package:healthapp/widgets/loading.dart';

class UpcomingPage extends StatefulWidget {
  @override
  static const id = "upcoming_page";

  _UpcomingPageState createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 90,
          color: Color(0xFFF8F8F8),
          child: StreamBuilder(
            stream:
                Firestore.instance.collection('booking_details').snapshots(),
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
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            buildItem(context, snapshot.data.documents[index]),
                        itemCount: snapshot.data.documents.length,
                        physics: new NeverScrollableScrollPhysics(),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        // Loading
        Positioned(child: isLoading ? const Loading() : Container()),
      ],
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document.data['id'] != globals.user.id) {
      if (document.data.length == 0)
        return Container(
          alignment: Alignment.center,
          child: Text(
            'You have no upcoming appointments!',
          ),
        );
      else
        return Container(
          height: 0,
        );
    } else {
      print(document.data['id']);
      String time = document.data['visitDuration'];
      time = time.split('-')[0];
      if (document['visitTime'] == 'Morning')
        time += ' AM';
      else
        time += ' PM';
      Timestamp visitDate = document.data['selectedDate'];
      String date =
          dateTimeConverter(visitDate.toDate().toString().split(' ')[0]);
      date = date.split(',')[0];
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _appointmentsTab(
            'assets/icons/doc1.png',
            document.data['doctorName'],
            document.data['visitType'],
            time,
            date),
      );
    }
  }

  Widget _appointmentsTab(
      String imgUrl, String name, String visitType, String time, String date) {
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
            trailing: _upcomingDate(
                date.split(" ")[0], date.split(" ")[1].substring(0, 3))),
      ),
    );
  }

  Widget _imageIcon(String imgUrl) {
    return Image(image: AssetImage(imgUrl));
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
}
