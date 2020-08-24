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