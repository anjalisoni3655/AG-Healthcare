import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthapp/screens/drawer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FacebookLogin facebookLogin = FacebookLogin();

String f_name;
String f_email;
String f_imageUrl;

Future<String> signInWithFacebook() async {
  final facebookLoginResult =
  await facebookLogin.logInWithReadPermissions(['email']);


  final FacebookAccessToken myToken = facebookLoginResult.accessToken;
  final AuthCredential credential =
  FacebookAuthProvider.getCredential(accessToken: myToken.token);

//  print(credential);
  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  f_name = user.displayName;
  f_email = user.email;
  f_imageUrl = user.photoUrl;
  f_imageUrl+='?height=500';

  type='Facebook';
  print(f_imageUrl);
  return 'SignIn with Facebook succeeded: $user';
}

void signOutFacebook() async {
  await facebookLogin.logOut();
  print('Facebook LogOut Successful!');
}