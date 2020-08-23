import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customAppBar(String text, var context){
  return AppBar(
    backgroundColor: Color(0xFFF8F8F8),
    elevation: 0,
    centerTitle: true,
    title: Text(
      text,
      style: GoogleFonts.varelaRound(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Color(0xFF262626),
      ),
    ),
    leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios, color: Colors.blue[700],)),
  );
}