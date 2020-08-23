import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class AppointmentPage extends StatefulWidget {
  @override
  static const id = "appointments_page";

  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF8F8F8),
      child: Container(
        color: Color(0xFFF8F8F8),
        height: double.infinity,
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              for (var i = 0; i < 4; i++)
                _appointmentsTab('assets/icons/' + doc_images[i] + '.png',
                    doc_names[i], type[i], visitType[i], time[i], date[i]),
            ],
          ),
        ),
      ),
    );
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
          subtitle: (type == 'Future')
              ? _upcomingSubtitle(visitType, time)
              : _ongoingOrCompletedSubtitle(type, message),
          trailing: (type == 'Future')
              ? _upcomingDate(date.split(" ")[0], date.split(" ")[1])
              : null,
        ),
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
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
