import 'package:flutter/material.dart';
import 'package:react_messenger/utils/colors.dart';

import '../../const/const.dart';
import '../../controller/resources/auth_methods.dart';
import 'home_screen.dart';
import '../../utils/text_widget.dart';
import '../../utils/utils.dart';
import '../widgets/login_bottom_container.dart';
import '../widgets/text_field_input.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const MobileScreenLayout(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => const SignUpScreen(),
      ),
    );
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
                  ElevatedButton(
                    onPressed: () async {
                      await loginUser();
                    },
                    style: buttonStyle,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: primaryColor,
                          ))
                        : const Text('SignUp'),
                  ),
                  kHeight25,
                  //transition to signing up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const LoginBottomContainer(
                          title: "Don't have an account"),
                      GestureDetector(
                        onTap: navigateToSignUp,
                        child: const LoginBottomContainer(
                            title: 'Sign Up', fontWeight: FontWeight.bold),
                      ),
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
