import 'package:flutter/material.dart';

const Widget kHeight50 = SizedBox(
  height: 50,
);
const Widget kHeight25 = SizedBox(
  height: 25,
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
