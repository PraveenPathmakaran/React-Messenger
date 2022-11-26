import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton(
      {super.key,
      this.function,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor});
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .35,
          height: MediaQuery.of(context).size.width * .08,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
