import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle headlineTextStyle(double size) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: size,
    );
  }

  static TextStyle lightTextStyle(double size) {
    return TextStyle(fontFamily: 'Poppins1', color: Colors.black, fontSize: size);
  }
   static TextStyle whiteTextStyle(double size) {
    return TextStyle(fontFamily: 'Poppins1', color: Colors.white, fontSize: size);
  }

  static Widget selectedCategory(String name) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),

        child: Center(
          child: Text(
            'All Medicines',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
