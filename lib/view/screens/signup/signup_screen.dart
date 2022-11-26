import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:react_messenger/controller/login_controller.dart';
import 'package:react_messenger/controller/signup_controller.dart';
import '../../../const/const.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../widgets/login_bottom_container.dart';
import '../../widgets/text_field_input.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final SignUpController signUpController = Get.put(SignUpController());
  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //Heading
                  kHeight25,
                  Image(
                    image: const AssetImage('assets/images/logo.png'),
                    height: width * .25,
                  ),

                  //profile image
                  Obx(() {
                    return Stack(
                      children: <Widget>[
                        if (signUpController.image.value != null)
                          CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                FileImage(File(signUpController.image.value!)),
                            backgroundColor: Colors.transparent,
                          )
                        else
                          GestureDetector(
                            onTap: () async {
                              signUpController.image.value =
                                  await pickImage(ImageSource.gallery);
                            },
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Lottie.asset('assets/imageadd.json'),
                            ),
                          ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        )
                      ],
                    );
                  }),

                  kHeight10,
                  //text field input for email
                  TextFieldInput(
                    textEditingController: signUpController.emailController,
                    hintText: 'Enter your Email',
                    textInputType: TextInputType.emailAddress,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                  kHeight10,

                  TextFieldInput(
                    textEditingController: signUpController.usernameController,
                    hintText: 'Username',
                    textInputType: TextInputType.text,
                    label: 'Username',
                    icon: Icons.manage_accounts_rounded,
                  ),
                  kHeight10,
                  //text field input for password
                  TextFieldInput(
                    textEditingController: signUpController.passwordController,
                    hintText: 'Enter your Password',
                    textInputType: TextInputType.text,
                    isPass: true,
                    label: 'Password',
                    icon: Icons.lock,
                  ),
                  kHeight10,
                  TextFieldInput(
                    textEditingController:
                        signUpController.conformPasswordController,
                    hintText: 'Conform your passoword',
                    textInputType: TextInputType.text,
                    isPass: true,
                    label: "Conform password",
                    icon: Icons.lock,
                  ),
                  kHeight25,
                  //button login

                  ElevatedButton(
                    onPressed: () async {
                      await signUpController.signUpUser(context);
                    },
                    style: buttonStyle,
                    child: Obx(
                      () {
                        return signUpController.isLoading.value
                            ? circularProgressIndicator
                            : const Text('SignUp');
                      },
                    ),
                  ),
                  kHeight10,
                  const LoginBottomContainer(title: 'Or sign in with'),
                  Obx(() {
                    return GestureDetector(
                      onTap: () async {
                        await loginController.googleSignup();
                      },
                      child: loginController.gIsLoading.value
                          ? circularProgressIndicator
                          : const Image(
                              width: 40,
                              image: AssetImage('assets/images/google.png'),
                            ),
                    );
                  }),
                  //transition to signing up
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LoginBottomContainer(
                              title: 'Already have account ? '),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                signUpController.clearFieled();
                              },
                              child: const LoginBottomContainer(
                                title: 'Login',
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              )),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
