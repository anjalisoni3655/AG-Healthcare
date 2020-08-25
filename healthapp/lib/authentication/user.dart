import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> uploadUserDetails({
  String name,
  String email,
  String gender,
  String address,
  int age,
  int phone,
  String dob,
  String blood,
  int height,
  int weight,
  String marital,
}) async {
  await Firestore.instance.collection('user_details').document().setData(
    {
      'name': name,
      'email': email,
      'gender': gender,
      'phone': phone,
      'dob': dob,
      'address': address,
      'age': age,
      'blood': blood,
      'height': height,
      'weight': weight,
      'marital': marital,
    },
  );
}
Future<void> uploadBookingDetails({
  String doctorName,
  String years,
  String field,
  String cost,
 
}) async {
  await Firestore.instance.collection('booking_details').document().setData(
    {
      'doctorName': doctorName,
      'years':years,
      'field': field,
      'cost':cost,
      
    },
  );
}