import 'dart:developer';

import 'package:get/get.dart';

import '../models/user.dart';
import '../services/auth_methods.dart';

class UserController extends GetxController {
  final Rxn<User> userData = Rxn<User>();
  AuthMethods currentUser = AuthMethods();

  Future<void> getUser() async {
    try {
      userData.value = await currentUser.getUserDetails();
    } catch (e) {
      log('userController ${e.toString()}');
    }
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }
}
