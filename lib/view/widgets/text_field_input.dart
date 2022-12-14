import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType,
      required this.label,
      required this.icon});

  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(50));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(label),
        labelStyle: const TextStyle(color: Colors.white),
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(10),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
