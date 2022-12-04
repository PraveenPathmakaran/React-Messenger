import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import 'user_controller.dart';

class UserListController extends GetxController {
  RxList<User> userList = <User>[].obs;
  String? userId;
  RxBool isLoading = false.obs;

//get all follow or followers id
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final UserController userController = Get.put(UserController());

  Future<void> usersListGet(
    String dataName,
  ) async {
    isLoading.value = true;
    final DocumentSnapshot<Map<String, dynamic>> currentUserData =
        await firebaseFirestore.collection('user').doc(userId).get();
    final List<String> listOfData =
        (currentUserData.data()![dataName] as List<dynamic>)
            .map((dynamic e) => e as String)
            .toList();

    for (final String userId in listOfData) {
      final DocumentSnapshot<Map<String, dynamic>> userData =
          await firebaseFirestore.collection('user').doc(userId).get();
      userList.add(User.fromSnap(userData));
    }
    isLoading.value = false;
  }

//liked users list get
  Future<void> postLikesGet(String postId) async {
    isLoading.value = true;
    final DocumentSnapshot<Map<String, dynamic>> postData =
        await firebaseFirestore.collection('posts').doc(postId).get();
    final List<String> listOfPostData =
        (postData.data()!['likes'] as List<dynamic>)
            .map((dynamic e) => e as String)
            .toList();

    for (final String postId1 in listOfPostData) {
      final DocumentSnapshot<Map<String, dynamic>> userData =
          await firebaseFirestore.collection('user').doc(postId1).get();
      userList.add(User.fromSnap(userData));
    }
    isLoading.value = false;
  }
}
