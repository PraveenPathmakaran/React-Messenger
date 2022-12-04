import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../services/firestore_methods.dart';
import '../utils/utils.dart';

class ReportController extends GetxController {
  TextEditingController reportTextEditingController = TextEditingController();
  String result = 'error';
  Rx<bool> isLoading = false.obs;
  bool mounted = true;
  Future<void> postReport(String postId, String postUserid,
      String reportedUserId, BuildContext context) async {
    isLoading.value = true;
    result = await FirestoreMethods().reportPost(
      <String, dynamic>{
        'postId': postId,
        'postUserId': postUserid,
        'reportUserId': reportedUserId,
        'reason': reportTextEditingController.text,
      },
    );
    isLoading.value = false;
    reportTextEditingController.clear();
    if (!mounted) {
      return;
    }
    showSnackBar(result, context);
  }
}
