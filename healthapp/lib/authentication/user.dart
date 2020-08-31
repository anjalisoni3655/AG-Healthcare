library globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthapp/authentication/user.dart' as globals;

class User {
  int cost;
  String email;
  String paymentId;
  int phone;
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
        print( value.data);
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

void getPatientofGivenBookingId(String paymentId) {
  Firestore.instance
      .collection("booking_details")
      .where("paymentId", isEqualTo: paymentId)
      .getDocuments()
      .then((value) {
    value.documents.forEach((result) {
      print(result.data);
    });
  });
}
