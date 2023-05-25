import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue,
      width: 2.0,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blueAccent,
      width: 2.0,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 2.0,
    ),
  ),
);

void nextScreen(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
