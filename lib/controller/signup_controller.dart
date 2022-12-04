import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_methods.dart';
import '../utils/utils.dart';
import '../view/screens/login/login_screen.dart';
import 'user_controller.dart';

class SignUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final AuthMethods authMethods = AuthMethods();
  final UserController userController = Get.put(UserController());

  Rxn<String> image = Rxn<String>();
  Rx<bool> isLoading = false.obs;
  bool mounted = true; //lint remove
  Future<void> signUpUser(BuildContext context) async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        usernameController.text.isEmpty ||
        image.value == null) {
      //image validation
      if (image.value == null) {
        showSnackBar('Please add a profile image', context);
        return;
      }

      //email validation
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text);

      if (!emailValid) {
        return showSnackBar('Enter a valid email address', context);
      }

      showSnackBar('All fileds are mandatory', context);
      return;
    }

    if (passwordController.text != conformPasswordController.text) {
      showSnackBar('Password doest not match', context);
      if (passwordController.text.length < 6) {
        showSnackBar('Password length should be 6', context);
      }
      return;
    }

    isLoading.value = true;
    final String res = await authMethods.signUpUser(
      email: emailController.text,
      rePassword: conformPasswordController.text,
      username: usernameController.text,
      password: passwordController.text,
      file: image.value!,
    );

    isLoading.value = false;

    if (!mounted) {
      return;
    } //for linter remove build context async gap

    if (res != 'success') {
      if (res ==
          '[firebase_auth/invalid-email] The email address is badly formatted.') {
        showSnackBar('Please enter a valid email address', context);
        return;
      }

      if (res ==
          '[firebase_auth/weak-password] Password should be at least 6 characters') {
        showSnackBar('Password should be atleast 6 character', context);
        return;
      }
      if (res ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        showSnackBar(
            'The email address is already in use by another account', context);
        return;
      }
      showSnackBar(res, context);
    } else {
      Get.offAll(() => LoginScreen());
      showSnackBar('Sign up Successfull', context);
      authMethods.signOut();
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pop(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => LoginScreen(),
      ),
    );
    clearFieled();
  }

  void clearFieled() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    conformPasswordController.clear();
    image.value = null;
  }

  Future<void> updateUserController(String userId, BuildContext context) async {
    isLoading.value = true;
    final String result = await authMethods.updateUser(
        username: usernameController.text,
        bio: bioController.text,
        userId: userId,
        file: image.value);
    if (result == 'success') {
      userController.getUser();

      Get.back();
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    conformPasswordController.dispose();
    usernameController.dispose();
    image.value = null;
    super.onClose();
  }
}
