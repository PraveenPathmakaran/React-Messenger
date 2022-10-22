import 'package:flutter/material.dart';

class LoginBottomContainer extends StatelessWidget {
  const LoginBottomContainer(
      {super.key, this.fontWeight = FontWeight.normal, required this.title});
  final FontWeight fontWeight;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontWeight: fontWeight),
      ),
    );
  }
}
