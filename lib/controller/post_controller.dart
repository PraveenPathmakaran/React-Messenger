import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  Rx<bool> isLikeAnimating = false.obs;
  Rx<int> commentLen = 0.obs;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> valueGet(String userUid) async {
    QuerySnapshot<Map<String, dynamic>> data = await firebaseFirestore
        .collection('user')
        .where('uid', isEqualTo: userUid)
        .get();
    return data.docs[0].data();
  }
}
