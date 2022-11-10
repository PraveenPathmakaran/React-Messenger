import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import '../view/screens/home/home_screen.dart';
import 'resources/auth_methods.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  Rx<bool> isLoading = false.obs;
  bool mounted = true;

  Future<void> loginUser(BuildContext context) async {
    isLoading.value = true;

    String res = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);
    if (!mounted) return; //for remove lint
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) => const MobileScreenLayout(),
          ),
          (Route<dynamic> route) => false);
    } else {
      showSnackBar(res, context);
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}