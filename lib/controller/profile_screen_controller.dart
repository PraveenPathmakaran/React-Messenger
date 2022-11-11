import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/resources/user_controller.dart';
import 'package:react_messenger/utils/utils.dart';

class ProfileScreenController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rxn<dynamic> userData = Rxn<Map<dynamic, dynamic>>();
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  getData({required BuildContext context, required String uid}) async {
    try {
      isLoading.value = true;

      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      //get Post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postSnap.docs.length;
      userData.value = userSnap.data()! as Map<dynamic, dynamic>;
      followers = userData.value['followers'].length;
      following = userData.value['following'].length;
      isFollowing = userData.value['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
