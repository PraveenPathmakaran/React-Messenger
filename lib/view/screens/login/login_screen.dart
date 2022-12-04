import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../const/const.dart';
import '../../../controller/login_controller.dart';
import '../../../widgets/widgets.dart';
import '../../widgets/login_bottom_container.dart';
import '../../widgets/text_field_input.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    kHeight50,
                    //Heading
                    Image(
                      image: const AssetImage('assets/images/logo.png'),
                      height: width * .25,
                    ),
                    SizedBox(
                      height: width * .50,
                      width: width,
                      child: Lottie.asset('assets/loginlottie.json',
                          fit: BoxFit.cover),
                    ),

                    kHeight50,
                    //text field input for email
                    TextFieldInput(
                      textEditingController: loginController.emailController,
                      hintText: 'Enter your Email',
                      textInputType: TextInputType.emailAddress,
                      label: 'Email',
                      icon: Icons.email,
                    ),
                    kHeight25,
                    //text field input for password
                    TextFieldInput(
                      textEditingController: loginController.passwordController,
                      hintText: 'Enter your Password',
                      textInputType: TextInputType.text,
                      isPass: true,
                      label: 'Password',
                      icon: Icons.lock,
                    ),

                    kHeight25,

                    ElevatedButton(
                        onPressed: () async {
                          await loginController.loginUser(context);
                        },
                        style: buttonStyle,
                        child: Obx(() {
                          return loginController.isLoading.value
                              ? circularProgressIndicator
                              : const Text('Log In');
                        })),
                    kHeight25,
                    const LoginBottomContainer(title: 'Or login in with'),
                    Obx(() {
                      return GestureDetector(
                        onTap: () async {
                          await loginController.googleLogin(context);
                        },
                        child: loginController.gIsLoading.value
                            ? circularProgressIndicator
                            : const Image(
                                width: 40,
                                image: AssetImage('assets/images/google.png'),
                              ),
                      );
                    }),
                    kHeight10,
                    //transition to signing up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const LoginBottomContainer(
                            title: "Don't have an account?"),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<Widget>(
                              builder: (BuildContext context) => SignUpScreen(),
                            ),
                          ),
                          child: const LoginBottomContainer(
                            title: '  Sign Up',
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
