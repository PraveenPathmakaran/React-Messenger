import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'profile_screen_controller.dart';
import 'package:react_messenger/controller/user_controller.dart';

import '../models/user.dart';

class UserListController extends GetxController {
  RxList<User> userList = <User>[].obs;
  String? userId;
  RxBool isLoading = false.obs;

//get all follow or followers id
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final UserController userController = Get.put(UserController());
  final ProfileScreenController profileScreenController =
      Get.put(ProfileScreenController());

  Future<void> usersListGet(String dataName) async {
    isLoading.value = true;
    final currentUserData =
        await firebaseFirestore.collection('user').doc(userId).get();
    final listOfData = currentUserData.data()![dataName];

    for (final String userId in listOfData) {
      final userData =
          await firebaseFirestore.collection('user').doc(userId).get();
      userList.add(User.fromSnap(userData));
    }
    isLoading.value = false;
  }

//liked users list get
  Future<void> postLikesGet(String postId) async {
    isLoading.value = true;
    final postData =
        await firebaseFirestore.collection('posts').doc(postId).get();
    final listOfPostData = postData.data()!['likes'];

    for (final String postId1 in listOfPostData) {
      final userData =
          await firebaseFirestore.collection('user').doc(postId1).get();
      userList.add(User.fromSnap(userData));
    }
    isLoading.value = false;
  }
}
