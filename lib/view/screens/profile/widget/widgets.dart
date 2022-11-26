import 'package:flutter/material.dart';

Column buildStatColumn(
  int num,
  String label,
  double width,
) {
  return Column(
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        width: width / 4,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      )
    ],
  );
}
