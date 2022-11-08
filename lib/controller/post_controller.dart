import 'package:get/get.dart';

class PostController extends GetxController {
  Rx<bool> isLikeAnimating = false.obs;
  Rx<int> commentLen = 0.obs;
}
