library globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/authentication/user.dart' as globals;

class User {
  int cost;
  String email;
  String paymentId;
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
  final _firestore = Firestore.instance;
  final _id = _firestore
      .collection('user_details')
      .document(globals.user.email)
      .documentID;
  await Firestore.instance
      .collection('user_details')
      .document(globals.user.email)
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
}) async {
  print('email:${globals.user.email}');
  final _firestore = Firestore.instance;
  final _id = _firestore
      .collection('booking_details')
      .document(globals.user.email)
      .documentID;
  await Firestore.instance
      .collection('booking_details')
      .document(globals.user.email)
      .setData(
    {
      'doctorName': doctorName,
      'years': years,
      'field': field,
      'cost': cost,
      'selectedDate': selectedDate,
      'visitTime': visitTime,
      'visitType': visitType,
      'visitDuration': visitDuration,
      'paymentId':paymentId,
    },
  );
  return _id;
}
// Future<List<String>> getBookings(String userId) async {
//   Firestore _database;

//     QuerySnapshot snapshot = await _database
//         .collection('policy')
//         .where('id', isEqualTo: userId)

//         .getDocuments();
//     List<String> list = [];
//     for (var doc in snapshot.documents) {
//       list.add(
//           new String(doc.data['cost']));
//     }
//     return list;
//   }
