import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/screens/book_appointments/doctor_details.dart';
import 'package:healthapp/widgets/app_bar.dart';
import 'package:healthapp/authentication/user.dart';

const List<String> doc_names = ['Dr. Amit Goel', 'Dr Sonali Gupta'];
const List<String> doc_images = ['doc1', 'doc2'];
const List<String> doc_fields = ['Oncologist', 'Gynecologist'];
const List<String> doc_exp = ['4Y Exp', '3Y Exp'];
const List<String> doc_costs = ['Rs 200', 'Rs 300'];

class DoctorsList extends StatefulWidget {
  @override
  static const id = "doctors_list";

  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('All doctors', context),
      body: Material(
        color: Color(0xFFF8F8F8),
        child: Container(
          color: Color(0xFFF8F8F8),
          height: double.infinity,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (var i = 0; i < 10; i++)
                  _doctorTile(
                      doc_names[i % 2],
                      'assets/icons/' + doc_images[i % 2] + '.png',
                      doc_fields[i % 2],
                      doc_exp[i % 2],
                      doc_costs[i % 2]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _doctorTile(String name, String imgUrl, String fields, String expYears,
      String costs) {
    String id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: RaisedButton(
        onPressed: () async {
          print(name);
       
          Navigator.pushNamed(context, DoctorDetails.id,arguments: {
            'name': name,
            'expYears': expYears,
            'fields': fields,
            'costs': costs,
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        color: Colors.white,
        elevation: 0,
        child: ListTile(
          leading: _imageIcon(imgUrl),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _doctorName(name),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subtitlesForDoctorTile(fields),
              _subtitlesForDoctorTile(expYears),
              _additionalSubtitle(costs, Color(0xFF08134D)),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _additionalSubtitle('BOOK', Color(0xFF408AEB)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageIcon(String imgUrl) {
    return Image(image: AssetImage(imgUrl));
  }

  Widget _doctorName(String name) {
    return Text(
      name,
      style: TextStyle(
          fontWeight: FontWeight.w600, color: Color(0xFF08134D), fontSize: 18),
    );
  }

  Widget _additionalSubtitle(String costs, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        costs,
        style:
            TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 15),
      ),
    );
  }

  Widget _subtitlesForDoctorTile(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFF8F8F8F),
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    );
  }
}
