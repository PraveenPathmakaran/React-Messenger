import 'package:flutter/material.dart';

//
final ButtonStyle buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(const Color(0xFFAD2DA9)),
  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 45)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
    ),
  ),
);

const String logoPath = 'assets/images/mainlogo.png';
