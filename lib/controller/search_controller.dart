import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final Rx<bool> isShowUsers = false.obs;
}
