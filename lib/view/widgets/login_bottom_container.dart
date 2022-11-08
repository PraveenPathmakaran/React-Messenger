import 'package:flutter/material.dart';

class LoginBottomContainer extends StatelessWidget {
  const LoginBottomContainer(
      {super.key,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.white,
      required this.title});
  final FontWeight fontWeight;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontWeight: fontWeight, color: color),
      ),
    );
  }
}
