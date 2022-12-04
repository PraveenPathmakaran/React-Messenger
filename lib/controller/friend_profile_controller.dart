import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../utils/utils.dart';
import 'user_controller.dart';

class FriendProfileScreenController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rxn<Map<dynamic, dynamic>> userData = Rxn<Map<dynamic, dynamic>>();
  int postLength = 0;
  Rx<int> followers = 0.obs;
  Rx<int> following = 0.obs;
  bool isFollowing = false;

  final UserController userController = Get.put(UserController());
  Future<void> getData(
      {required BuildContext context, required String? uid}) async {
    if (uid == null) {
      return;
    }
    try {
      isLoading.value = true;

      final DocumentSnapshot<Object?> userSnap =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();

      //get Post length
      final QuerySnapshot<Map<String, dynamic>> postSnap =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isEqualTo: uid)
              .get();
      postLength = postSnap.docs.length;
      userData.value = userSnap.data()! as Map<dynamic, dynamic>;
      followers.value = (userData.value!['followers'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList()
          .length;
      following.value = (userData.value!['following'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList()
          .length;
      isFollowing = (userData.value!['followers'] as List<dynamic>)
          .contains(userController.userData.value!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    isLoading.value = false;
  }
}
