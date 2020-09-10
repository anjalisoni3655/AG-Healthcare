library globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:healthapp/authentication/user.dart' as globals;

class User {
  int cost;
  String email;
  String paymentId;
  String phone;
  String photo;
  String name;
  String gender, dob, blood, marital, address;
  String height, weight;
  String id;
  String visitTime;
  String visitType;
  String visitDuration;
  String date;
}

User user = User();

Future<String> uploadUserDetails({
  String name,
  String email,
  String gender,
  String address,
  String dob,
  String blood,
  int height,
  int weight,
  String marital,
  String phone,
}) async {
  print('email:${globals.user.email}');
  final _firestore = Firestore.instance;
  final _id = _firestore.collection('user_details').document().documentID;
  print('userdetailsId:$_id');
  await Firestore.instance
      .collection('user_details')
      .document(globals.user.id)
      .setData(
    {
      'name': name,
      'email': email,
      'gender': gender,
      'dob': dob,
      'address': address,
      'blood': blood,
      'height': height,
      'weight': weight,
      'marital': marital,
      'phone': phone,
    },
  );
  return _id;
}

Future<String> uploadReviews({
  int rate,
  String comment,
}) async {
  // print('email:${globals.user.email}');
  final _firestore = Firestore.instance;
  final _id = _firestore.collection('review').document().documentID;
  // print('userdetailsId:$_id');
  await Firestore.instance.collection('review').document().setData(
    {
      'name': globals.user.name,
      'photo': globals.user.photo,
      'rate': rate,
      'comment': comment,
    },
  );
  return _id;
}

Future<String> uploadBookingDetails({
  String doctorName,
  String years,
  String field,
  String cost,
  DateTime selectedDate,
  String visitTime,
  String visitType,
  String visitDuration,
  String paymentId,
  String email,
  String id,
  String name,
  String photo,
  String phone,
  String reason_for_visit,
  String timesOfVisit,
}) async {
  print('email:${globals.user.email}');
  final _firestore = Firestore.instance;
  final _id = _firestore
      .collection('booking_details')
      .document(globals.user.id)
      .documentID;
  await Firestore.instance
      .collection('booking_details')
      .document(globals.user.id)
      .setData({
    'reason_for_visit': reason_for_visit,
    'timesOfVisit': timesOfVisit,
    'doctorName': doctorName,
    'years': years,
    'field': field,
    'cost': cost,
    'selectedDate': selectedDate,
    'visitTime': visitTime,
    'visitType': visitType,
    'visitDuration': visitDuration,
    'paymentId': paymentId,
    'email': email,
    'id': id,
    'photo': photo,
    'name': name,
    'phone': phone,
  }, merge: true).then((_) {
    print("payment id added");
  });

  return _id;
}

void getAllBookings() {
  Firestore.instance
      .collection("booking_details")
      .getDocuments()
      .then((querySnapshot) {
    querySnapshot.documents.forEach((result) {
      print(result.data);
    });
  });
}

void getPatientBooking() async {
  Firestore.instance
      .collection("booking_details")
      .document(globals.user.id)
      .get()
      .then((value) {
    print(value.data);
  });
}

void getDoctorDetails() async {
  final _firestore = Firestore.instance;
  final _id = _firestore.collection('doctor').document().documentID;
  print('id${_id}');
  Firestore.instance
      .collection("doctor")
      .document("5lXYnBBrxXvgU0dpZGId")
      .get()
      .then((value) {
    print(value.data['courses']);
  });
}

void getDoctorTimings() async {
  Firestore.instance
      .collection("doctor")
      .document("dramitgoelhyd@gmail.com")
      .get()
      .then((value) {
    //returns an array of timings
    print(value.data['monday']);
  });
}

void getAllPatientDetail() {
  Firestore.instance
      .collection("booking_details")
      .where("doctorName", isEqualTo: "Dr Amit Goel")
      .snapshots()
      .listen((result) {
    result.documents.forEach((result) {
      print(result.data);
    });
  });
}

void getPatientofGivenBookingId() {
  Firestore.instance.collection("messages").getDocuments().then((value) {
    value.documents.forEach((result) {
      print(result.data);
    });
  });
}

void getPrescriptionByPatient() {
  Firestore.instance
      .collection("messages")
      .getDocuments()
      .then((querySnapshot) {
    querySnapshot.documents.forEach((result) {
      Firestore.instance
          .collection("messages")
          .document(result.documentID)
          .collection(result.documentID)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          print('presCRIPTION');
          print(result.data);
        });
      });
    });
  });
}

void getPrescriptionByDoctor() {
  Firestore.instance
      .collection("messages")
      .getDocuments()
      .then((querySnapshot) {
    querySnapshot.documents.forEach((result) {
      Firestore.instance
          .collection("messages")
          .document("2GVoVBWHxtWdyfTDjpXN3RYzc1j1-w3xYinWd7OhOPF0GbC6lumihYAD2")
          .collection(
              "2GVoVBWHxtWdyfTDjpXN3RYzc1j1-w3xYinWd7OhOPF0GbC6lumihYAD2")
          .where('type', isEqualTo: 1)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          print(result.data['content']);
        });
      });
    });
  });
}
