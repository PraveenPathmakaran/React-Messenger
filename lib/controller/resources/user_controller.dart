import 'package:get/get.dart';
import 'package:react_messenger/controller/resources/auth_methods.dart';

import '../../models/user.dart';

class UserController extends GetxController {
  final Rxn<User> userData = Rxn<User>();
  AuthMethods currentUser = AuthMethods();

  Future<void> getUser() async {
    userData.value = await currentUser.getUserDetails();
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }
}
