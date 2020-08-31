import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:healthapp/utils/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/components/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthapp/screens/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/authentication/user.dart' as globals;

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

class Profile extends StatelessWidget {
  static const id = "profile";

  //User user;
//Profile({this.user});
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: _appBar(context),
      body: SettingsScreen(),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Edit Profile',
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF262626),
        ),
      ),
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
            onTap: () {
              Navigator.pushNamed(context, UserProfile.id);
            },
            child: Text(
              'SAVE',
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

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
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
            //TODO: chnage this photo with the one that user will uplaod
            'photo': photo,
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

  InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(7)),
  );

  TextStyle textStyle1 = TextStyle(
      color: Color(0xFF8F8F8F), fontSize: 15, fontWeight: FontWeight.w600);
  TextStyle textStyle2 = TextStyle(
      color: Color(0xFF606060), fontSize: 15, fontWeight: FontWeight.w600);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(int.parse(dob.split('-')[0]),
          int.parse(dob.split('-')[1]), int.parse(dob.split('-')[2])),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: GoogleFonts.nunitoTextTheme(),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF408AEB),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob = '${selectedDate.toLocal()}'.split(' ')[0];
      });
  }

  Widget _getDateTime(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(context);
        print(dob);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        child: Row(
          children: [
            (selectedDate == null)
                ? _getText(dateTimeConverter(dob), 15, Color(0xFF606060))
                : _getText(
                    dateTimeConverter(
                        '${selectedDate.toLocal()}'.split(' ')[0]),
                    15,
                    Color(0xFF606060)),
          ],
        ),
      ),
    );
  }

  Widget _getText(String text, double size, Color color) {
    return Text(
      text,
      style:
          TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w600),
    );
  }

  Widget _customButton(String text, double tSize, int index, double padding) {
    return Expanded(
      child: RaisedButton(
        elevation: 0,
        padding: EdgeInsets.all(padding),
        color: _bodyColor[index],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: _getText(text, tSize, _textColor[index]),
        onPressed: () {
          gender = _category[index];
          print(gender);
          setState(() {
            if (_bodyColor[index] == Color(0xFFFFFFFF)) {
              _bodyColor[index] = Color(0xFFDFE9F7);
              _textColor[index] = Color(0xFF408AEB);
              int i = 0, j = 1;
              if (index == 0) {
                i = 1;
                j = 2;
              } else if (index == 1) {
                i = 0;
                j = 2;
              }
              _bodyColor[i] = Color(0xFFFFFFFF);
              _bodyColor[j] = Color(0xFFFFFFFF);
              _textColor[i] = Color(0xFF8F8F8F);
              _textColor[j] = Color(0xFF8F8F8F);
            } else {
              _bodyColor[index] = Color(0xFFFFFFFF);
              _textColor[index] = Color(0xFF8F8F8F);
            }
          });
        },
      ),
    );
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
                                    imageUrl: photo,
                                    width: 130.0,
                                    height: 130.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 130.0,
                                  color: greyColor,
                                ))
                          : Material(
                              child: Image.file(avatarImageFile,
                                  width: 130.0,
                                  height: 130.0,
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      Positioned(
                        top: 80,
                        left: 80,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xFFDFE9F7)),
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFF408AEB)),
                            onPressed: getImage,
                            iconSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Username
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Your full name', style: textStyle1),
                  ),
                  TextField(
                    decoration: inputDecoration,
                    cursorColor: Color(0xFF8F8F8F),
                    cursorRadius: Radius.circular(10),
                    cursorWidth: 0.5,
                    style: textStyle2,
                    controller: controllerName,
                    onChanged: (value) {
                      name = value;
                    },
                    focusNode: focusNodeName,
                  ),

                  // About me
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Email Address', style: textStyle1),
                  ),
                  TextField(
                    decoration: inputDecoration,
                    cursorColor: Color(0xFF8F8F8F),
                    cursorRadius: Radius.circular(10),
                    cursorWidth: 0.5,
                    style: textStyle2,
                    controller: controllerEmail,
                    onChanged: (value) {
                      email = value;
                    },
                    focusNode: focusNodeEmail,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Gender', style: textStyle1),
                        ),
                        Row(
                          children: [
                            _customButton('Male', 18, 0, 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            _customButton('Female', 18, 1, 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            _customButton('Other', 18, 2, 20),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Blood Group', style: textStyle1),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: DropdownButton<String>(
                            value: blood,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            isExpanded: true,
                            underline: SizedBox(),
                            style: GoogleFonts.nunito(
                                color: Color(0xFF606060),
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                                blood = dropdownValue;
                              });
                            },
                            items: <String>[
                              'O+',
                              'O-',
                              'AB+',
                              'AB-',
                              'A+',
                              'A-',
                              'B+',
                              'B-'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Date of Birth', style: textStyle1),
                        ),
                        _getDateTime(context),
                      ],
                    ),
                  ),

                  // About me
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Height', style: textStyle1),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(7)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(7)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(7)),
                      hintText: 'cm',
                      hintStyle: TextStyle(
                          color: Color(0x6F8F8F8F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    cursorColor: Color(0xFF8F8F8F),
                    cursorRadius: Radius.circular(10),
                    cursorWidth: 0.5,
                    style: textStyle2,
                    controller: controllerheight,
                    onChanged: (value) {
                      height = value;
                    },
                    focusNode: focusNodeHeight,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              Column(
                children: <Widget>[
                  // Username
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Weight', style: textStyle1),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(7)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(7)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(7)),
                      hintText: 'kg',
                      hintStyle: TextStyle(
                          color: Color(0x6F8F8F8F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    cursorColor: Color(0xFF8F8F8F),
                    cursorRadius: Radius.circular(10),
                    cursorWidth: 0.5,
                    style: textStyle2,
                    controller: controllerweight,
                    onChanged: (value) {
                      weight = value;
                    },
                    focusNode: focusNodeWeight,
                  ),

                  // About me
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Address', style: textStyle1),
                  ),
                  TextField(
                    decoration: inputDecoration,
                    cursorColor: Color(0xFF8F8F8F),
                    cursorRadius: Radius.circular(10),
                    cursorWidth: 0.5,
                    style: textStyle2,
                    controller: controlleraddress,
                    onChanged: (value) {
                      address = value;
                    },
                    focusNode: focusNodeAddress,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              Column(
                children: <Widget>[
                  // Username
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Marital Status', style: textStyle1),
                  ),
                  TextField(
                    decoration: inputDecoration,
                    cursorColor: Color(0xFF8F8F8F),
                    cursorRadius: Radius.circular(10),
                    cursorWidth: 0.5,
                    style: textStyle2,
                    controller: controllermarital,
                    onChanged: (value) {
                      marital = value;
                    },
                    focusNode: focusNodeMarital,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                padding: EdgeInsets.only(bottom: 100, top: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        onPressed: handleUpdateData,
                        elevation: 10,
                        child: Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Color(0xFF408AEB),
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
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
