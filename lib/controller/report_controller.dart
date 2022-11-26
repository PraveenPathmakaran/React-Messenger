import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:react_messenger/services/firestore_methods.dart';
import 'package:react_messenger/utils/utils.dart';

class ReportController extends GetxController {
  TextEditingController reportTextEditingController = TextEditingController();
  String result = 'error';
  Rx<bool> isLoading = false.obs;
  bool mounted = true;
  postReport(String postId, String postUserid, String reportedUserId,
      BuildContext context) async {
    isLoading.value = true;
    result = await FirestoreMethods().reportPost({
      'postId': postId,
      'postUserId': postUserid,
      'reportUserId': reportedUserId,
      'reason': reportTextEditingController.text,
    });
    isLoading.value = false;
    if (!mounted) return;
    showSnackBar(result, context);
  }
}
