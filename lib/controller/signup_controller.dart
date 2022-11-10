import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/utils/utils.dart';
import 'package:react_messenger/view/screens/home/home_screen.dart';
import '../view/screens/login/login_screen.dart';
import 'resources/auth_methods.dart';

class SignUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController =
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
    if (passwordController.text != conformPasswordController.text) {
      showSnackBar('Password doest not match', context);
      return;
    }

    isLoading.value = true;
    final String res = await AuthMethods().signUpUser(
      email: emailController.text,
      rePassword: conformPasswordController.text,
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
        return;
      }
      if (res ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        showSnackBar(
            'The email address is already in use by another account', context);
        return;
      }

      log(res.toString());
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const MobileScreenLayout(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pop(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => LoginScreen(),
      ),
    );
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    conformPasswordController.clear();
    image.value = null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    conformPasswordController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}
