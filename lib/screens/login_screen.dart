import 'package:flutter/material.dart';

import '../const/const.dart';
import '../utils/text_widget.dart';
import '../widgets/login_bottom_container.dart';
import '../widgets/login_button.dart';
import '../widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 150,
                bottom: 80,
              ),
              child: Column(
                children: <Widget>[
                  //Heading
                  const TitleWidget(title: 'React Messenger'),
                  kHeight50,
                  const Image(
                    width: 40,
                    image: AssetImage('assets/images/google.png'),
                  ),
                  kHeight50,
                  //text field input for email
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your Email',
                      textInputType: TextInputType.emailAddress),
                  kHeight25,
                  //text field input for password
                  TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Enter your Password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  kHeight25,
                  //button login
                  const LoginButton(
                    text: 'Login',
                  ),
                  kHeight25,
                  //transition to signing up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      LoginBottomContainer(title: "Don't have an account"),
                      LoginBottomContainer(
                          title: 'Sign Up', fontWeight: FontWeight.bold),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
