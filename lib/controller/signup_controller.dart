import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/utils/utils.dart';
import '../view/screens/login/login_screen.dart';
import 'resources/auth_methods.dart';

class SignUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  Rxn<String> image = Rxn();
  Rx<bool> isLoading = false.obs;
  bool mounted = true;
  Future<void> signUpUser(BuildContext context) async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        usernameController.text.isEmpty ||
        image.value == null) {
      if (image.value == null) {
        showSnackBar('Please add a profile image', context);
        return;
      }
      showSnackBar('All fileds are mandatory', context);
      return;
    }
    if (passwordController.text != reEnterPasswordController.text) {
      showSnackBar('Password doest not match', context);
      return;
    }

    isLoading.value = true;
    final String res = await AuthMethods().signUpUser(
      email: emailController.text,
      rePassword: reEnterPasswordController.text,
      username: usernameController.text,
      password: passwordController.text,
      file: image.value!,
    );

    isLoading.value = false;

    if (!mounted) return; //for linter remove build context async gap

    if (res != 'success') {
      if (res ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        showSnackBar('Please enter a valid email address', context);
        return;
      }

      if (res ==
          "[firebase_auth/weak-password] Password should be at least 6 characters") {
        showSnackBar('Password should be atleast 6 character', context);
      }

      log(res.toString());
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => LoginScreen(),
        ),
      );
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => LoginScreen(),
      ),
    );
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    reEnterPasswordController.clear();
    image.value = null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    reEnterPasswordController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}
