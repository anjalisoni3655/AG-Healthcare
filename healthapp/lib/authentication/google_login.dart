import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:healthapp/screens/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthapp/authentication/user.dart' as globals;

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
SharedPreferences prefs;

bool isLoading = false;
bool isLoggedIn = false;
FirebaseUser currentUser;

Future<Null> handleSignIn(BuildContext context) async {
  prefs = await SharedPreferences.getInstance();

  try {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      globals.user.email = firebaseUser.email;
      //  globals.user.photo = firebaseUser.photoUrl;
      // print('email');
      // print(globals.user.email);
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('user')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      //  if (documents.length == 0) {
      // globals.user.name = currentUser.displayName;
      // globals.user.email = currentUser.email;
      // Update data to server if new user
      Firestore.instance
          .collection('user')
          .document(firebaseUser.uid)
          .setData({
        'name': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoUrl,
        'id': firebaseUser.uid,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null,
        'email': firebaseUser.email,
      });

      // Write data to local
      currentUser = firebaseUser;
      globals.user.photo = firebaseUser.photoUrl;
      globals.user.id = firebaseUser.uid;
      globals.user.name = firebaseUser.displayName;
      globals.user.email = firebaseUser.email;
      print('NAME ${globals.user.name}');
      print('EMAIL ${globals.user.email}');
      print('photo ${globals.user.photo}');
      print('id ${globals.user.id}');
      await prefs.setString('id', currentUser.uid);
      await prefs.setString('name', currentUser.displayName);
      await prefs.setString('photo', currentUser.photoUrl);
      await prefs.setString('email', currentUser.email);
      // } else {
      // Write data to local

      // // globals.user.id = documents[0]['id'];
      // globals.user.name = documents[0]['name'];
      // globals.user.email = documents[0]['email'];
      // globals.user.photo = documents[0]['photoUrl'];
      // globals.user.id = documents[0]['id'];
      // print(globals.user.email);
      // print(documents[0]['email']);
      // await prefs.setString('id', documents[0]['id']);
      // await prefs.setString('name', documents[0]['name']);
      // await prefs.setString('email', documents[0]['email']);
      // await prefs.setString('photo', documents[0]['photoUrl']);
      // await prefs.setString('aboutMe', documents[0]['aboutMe']);
      //  }
      print("Successfully Signed in");

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserForm(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in failed, Try Again");
      print("Sign in failed, Try Again");
    }
  } catch (e) {
    print(e.toString());
    print('Exception Caught!');
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("Google Sign Out Successful");
  }
}