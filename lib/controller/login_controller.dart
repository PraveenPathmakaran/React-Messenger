import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/auth_methods.dart';
import '../utils/utils.dart';
import '../view/screens/home/home_screen.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Rx<bool> isLoading = false.obs;
  Rx<bool> gIsLoading = false.obs;
  bool mounted = true;

  Future<void> loginUser(BuildContext context) async {
    isLoading.value = true;
    final String res = await AuthMethods().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    if (!mounted) {
      return;
    } //for remove lint
    if (res == 'success') {
      if (await Permission.storage.status.isGranted) {
        await Future<dynamic>.delayed(
          const Duration(seconds: 2),
        );
        Get.off(const MobileScreenLayout());
        emailController.clear();
        passwordController.clear();
      } else {
        Get.snackbar('Error', 'Permission denied');
      }
    } else {
      showSnackBar(res, context);
    }

    isLoading.value = false;
  }

  Future<void> googleSignup() async {
    final String result = await AuthMethods().googleSingUp();
    if (result == 'Success') {
      if (await Permission.storage.status.isGranted) {
        await Future<dynamic>.delayed(
          const Duration(seconds: 2),
        );
        Get.off(() => const MobileScreenLayout());
      } else {
        Get.snackbar('Error', 'Permission denied');
      }
    } else {
      Get.snackbar('Error', result);
    }
  }

  Future<void> googleLogin(BuildContext context) async {
    final String result = await AuthMethods().googleLogin(context);
    if (result == 'Success') {
      if (await Permission.storage.status.isGranted) {
        await Future<dynamic>.delayed(
          const Duration(seconds: 2),
        );
        Get.off(() => const MobileScreenLayout());
      } else {
        Get.snackbar('Error', 'Permission denied');
      }
    } else {
      Get.snackbar('Error', result);
    }
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
