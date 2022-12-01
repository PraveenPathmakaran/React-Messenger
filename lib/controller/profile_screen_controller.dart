import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../utils/utils.dart';

class ProfileScreenController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rxn<dynamic> userData = Rxn<Map<dynamic, dynamic>>();
  int postLength = 0;
  Rx<int> followers = 0.obs;
  Rx<int> following = 0.obs;
  bool isFollowing = false;
  getData({required BuildContext context, required String uid}) async {
    try {
      isLoading.value = true;

      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();

      //get Post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();
      postLength = postSnap.docs.length;
      userData.value = userSnap.data()! as Map<dynamic, dynamic>;
      followers.value = userData.value['followers'].length;
      following.value = userData.value['following'].length;
      isFollowing = userData.value['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    isLoading.value = false;
  }
}
