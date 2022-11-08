import 'package:flutter/material.dart';

const Widget kHeight50 = SizedBox(
  height: 50,
);
const Widget kHeight25 = SizedBox(
  height: 25,
);
const Widget kHeight10 = SizedBox(
  height: 10,
);
const Widget kWidth15 = SizedBox(
  width: 15,
);
const Widget circularProgressIndicator = Center(
  child: CircularProgressIndicator(
    color: Colors.white,
  ),
);
final ButtonStyle buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(const Color(0xFFAD2DA9)),
  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 45)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
    ),
  ),
);
