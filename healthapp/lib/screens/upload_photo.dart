import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/components/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/authentication/user.dart' as globals;
import 'package:healthapp/screens/home_screen.dart';
import 'home_screen.dart';

List<Color> _textColor = [
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
  Color(0xFF8F8F8F),
];
List<Color> _bodyColor = [
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
  Color(0xFFFFFFFF),
];
List<String> _category = ['Male', 'Female', 'Other'];
DateTime selectedDate;
String dropdownValue;

class UploadPhoto extends StatefulWidget {
  static const id = "uploadPhoto";

  final String currentUserId;

  UploadPhoto({Key key, @required this.currentUserId}) : super(key: key);
  @override
  UploadPhotoState createState() => UploadPhotoState();
}

class UploadPhotoState extends State<UploadPhoto>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SettingsScreenPhoto(),
    );
  }

  Widget _appBar(BuildContext context) {
    // getPatient();
    return AppBar(
      backgroundColor: Color(0xFFF8F8F8),
      elevation: 0,
      leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue[700],
          )),
      actions: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                          currentUserId: widget.currentUserId)));
            },
            child: Text(
              'DONE',
              style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF408AEB)),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsScreenPhoto extends StatefulWidget {
  @override
  State createState() => SettingsScreenStatePhoto();
}

class SettingsScreenStatePhoto extends State<SettingsScreenPhoto> {
  TextEditingController controllerName;
  TextEditingController controllerEmail;
  TextEditingController controllergender;
  TextEditingController controllerdob;
  TextEditingController controllerblood;
  TextEditingController controllerheight;
  TextEditingController controllerweight;
  TextEditingController controllermarital;
  TextEditingController controlleraddress;

  SharedPreferences prefs;

  String id = '';
  String photo = '';
  String name;
  String email = '';

  String gender = '';

  int age;
  int phone;
  String dob = '';
  String blood = '';
  String height;
  String weight;
  String marital = '';
  String address = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeGender = FocusNode();

  final FocusNode focusNodeDob = FocusNode();

  final FocusNode focusNodeBlood = FocusNode();
  final FocusNode focusNodeHeight = FocusNode();
  final FocusNode focusNodeWeight = FocusNode();
  final FocusNode focusNodeMarital = FocusNode();
  final FocusNode focusNodeAddress = FocusNode();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    name = prefs.getString('name') ?? '';
    email = prefs.getString('email') ?? '';
    photo = prefs.getString('photo') ?? '';
    gender = prefs.getString('gender') ?? '';
    dob = prefs.getString('dob') ?? '';
    blood = prefs.getString('blood') ?? '';
    height = prefs.getString('height') ?? '';

    weight = prefs.getString('weight') ?? '';
    marital = prefs.getString('marital') ?? '';
    address = prefs.getString('address') ?? '';

    controllerName = TextEditingController(text: name);
    controllerEmail = TextEditingController(text: email);

    controllergender = TextEditingController(text: gender);
    controllerdob = TextEditingController(text: dob);
    controllerblood = TextEditingController(text: blood);
    controllerheight = TextEditingController(text: height);
    controllerweight = TextEditingController(text: weight);
    controllermarital = TextEditingController(text: marital);
    controlleraddress = TextEditingController(text: address);

    int ind;
    if (gender == 'Male')
      ind = 0;
    else if (gender == 'Female')
      ind = 1;
    else
      ind = 2;

    _textColor[ind] = Color(0xFF408AEB);
    _bodyColor[ind] = Color(0xFFDFE9F7);
    int i = 0, j = 1;
    if (ind == 0) {
      i = 1;
      j = 2;
    } else if (ind == 1) {
      i = 0;
      j = 2;
    }
    _bodyColor[i] = Color(0xFFFFFFFF);
    _bodyColor[j] = Color(0xFFFFFFFF);
    _textColor[i] = Color(0xFF8F8F8F);
    _textColor[j] = Color(0xFF8F8F8F);

    // Force refresh input
    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    File image = File(pickedFile.path);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photo = downloadUrl;
          final _id = Firestore.instance
              .collection('user_details')
              .document()
              .documentID;
          Firestore.instance
              .collection('user_details')
              .document(globals.user.id)
              .updateData({
            //TODO: change this photo with the one that user will uplaod
            'photo': photo,
            'name': name,
            'email': email,
            //TODO: change this photo with the one that user will uplaod
            //'photo': globals.user.photo,
            'gender': gender,
            'dob': dob,
            'blood': blood,
            'height': height,
            'weight': weight,
            'marital': marital,
            'address': address,
          }).then((data) async {
            await prefs.setString('photo', photo);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Uploaded Successfully");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeName.unfocus();
    focusNodeEmail.unfocus();
    focusNodeGender.unfocus();
    focusNodeDob.unfocus();
    focusNodeBlood.unfocus();
    focusNodeHeight.unfocus();
    focusNodeWeight.unfocus();
    focusNodeMarital.unfocus();
    focusNodeAddress.unfocus();
    // focusNodeEmail.unfocus();

    setState(() {
      isLoading = true;
    });
    final id =
        Firestore.instance.collection('user_details').document().documentID;
    Firestore.instance
        .collection('user_details')
        .document(globals.user.id)
        .updateData({
      'name': name,
      'email': email,
      //TODO: chnage this photo with the one that user will uplaod
      //'photo': globals.user.photo,
      'gender': gender,
      'dob': dob,
      'blood': blood,
      'height': height,
      'weight': weight,
      'marital': marital,
      'address': address,
    }).then((data) async {
      await prefs.setString('name', name);
      await prefs.setString('email', email);
      await prefs.setString('address', address);
      await prefs.setString('marital', marital);
      await prefs.setString('height', height);
      await prefs.setString('weight', weight);
      await prefs.setString('dob', dob);
      await prefs.setString('blood', blood);
      await prefs.setString('gender', gender);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Successfully updated");
      print(email);
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Text(
                  'Upload your picture!',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF08134D),
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 10, bottom: 50),
              ),
              Container(
                color: Color(0xFFF8F8F8),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photo != ''
                          ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  themeColor),
                            ),
                            width: 90.0,
                            height: 90.0,
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: photo.substring(0,photo.length-5)+'s400-c',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(100.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                          : Icon(
                        Icons.account_circle,
                        size: 200.0,
                        color: greyColor,
                      ))
                          : Material(
                        child: Image.file(avatarImageFile,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover),
                        borderRadius:
                        BorderRadius.all(Radius.circular(100.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      Positioned(
                        top: 150,
                        left: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xFFDFE9F7)),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Color(0xFF408AEB)),
                            onPressed: getImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Button
              // Container(
              //   padding: EdgeInsets.only(top: 100),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: RaisedButton(
              //           onPressed: handleUpdateData,
              //           elevation: 10,
              //           child: Text(
              //             'Update',
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           color: Color(0xFF408AEB),
              //           padding: EdgeInsets.all(20),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(7)),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        ),
      ],
    );
  }
}
