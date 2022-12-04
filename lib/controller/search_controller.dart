import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final Rx<bool> isShowUsers = false.obs;
  String name = '';

  final Rxn<QuerySnapshot<Map<String, dynamic>>> postDocumentList =
      Rxn<QuerySnapshot<Map<String, dynamic>>>();
  Future<void> initSearchingPost(String textEntered) async {
    if (textEntered == '') {
      return;
    }
    postDocumentList.value = await FirebaseFirestore.instance
        .collection('user')
        .where(
          'username',
          isGreaterThanOrEqualTo: textEntered,
        )
        .get();
  }
}
