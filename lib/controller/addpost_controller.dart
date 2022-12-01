import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_methods.dart';
import '../services/firestore_methods.dart';
import '../utils/utils.dart';
import 'user_controller.dart';

class AddPostController extends GetxController {
  final Rxn<String> filePath = Rxn<String>();
  final Rx<bool> isLoading = false.obs;

  final bool mounted = true;
  Rx<double> progress = 0.0.obs;

  AuthMethods currentUser = AuthMethods();
  final UserController userController = Get.put(UserController());

  Future<void> selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: <Widget>[
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final String filePath = await pickImage(ImageSource.camera);

                  addPath(filePath);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final String filePath = await pickImage(ImageSource.gallery);
                  addPath(filePath);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> postImage(
    BuildContext context,
    String description,
  ) async {
    isLoading.value = true;

    try {
      final String res = await FirestoreMethods().uploadPost(
        description,
        filePath.value!,
        userController.userData.value!.uid,
        userController.userData.value!.username,
        userController.userData.value!.photoUrl,
      );

      if (!mounted) {
        return;
      } //for removing build context in asynchronous gap
      if (res == 'Success') {
        isLoading.value = false;
        filePath.value = null;
        showSnackBar('Posted', context);
      } else {
        isLoading.value = false;
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void addPath(String path) {
    filePath.value = path;
  }
}
