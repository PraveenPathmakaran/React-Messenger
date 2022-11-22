import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:react_messenger/controller/user_controller.dart';
import 'package:react_messenger/services/auth_methods.dart';
import 'package:react_messenger/services/firestore_methods.dart';
import 'package:react_messenger/utils/utils.dart';

class AddPostController extends GetxController {
  final Rxn<String> filePath = Rxn<String>();
  final Rx<bool> isLoading = false.obs;

  final bool mounted = true;
  Rx<double> progress = 0.0.obs;

  AuthMethods currentUser = AuthMethods();
  final UserController userController = Get.put(UserController());

  selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  String filePath = await pickImage(ImageSource.camera);

                  addPath(filePath);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  String filePath = await pickImage(ImageSource.gallery);
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
      String res = await FirestoreMethods().uploadPost(
        description,
        filePath.value!,
        userController.userData.value!.uid,
        userController.userData.value!.username,
        userController.userData.value!.photoUrl,
      );

      if (!mounted) return; //for removing build context in asynchronous gap
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
