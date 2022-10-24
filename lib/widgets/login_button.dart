import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.text,
    required this.email,
    required this.password,
    required this.fullname,
    required this.username,
  });
  final String text;
  final String email;
  final String password;
  final String fullname;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final res = await AuthMethods().signUpUser(
          email: email,
          fullname: password,
          username: fullname,
          password: password,
        );
        print(res);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFAD2DA9)),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 45)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
