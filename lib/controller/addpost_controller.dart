import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:react_messenger/controller/resources/auth_methods.dart';
import 'package:react_messenger/controller/resources/firestore_methods.dart';
import 'package:react_messenger/utils/utils.dart';
import '../models/user.dart';

class AddPostController extends GetxController {
  final Rxn<String> filePath = Rxn<String>();
  final Rx<bool> isLoading = false.obs;
  final Rxn<User> userData = Rxn<User>();

  AuthMethods currentUser = AuthMethods();

  Future<void> getUser() async {
    try {
      userData.value = await currentUser.getUserDetails();
    } catch (e) {
      log(e.toString());
    }
  }

  void addPath(String path) {
    filePath.value = path;
  }

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
        userData.value!.uid,
        userData.value!.username,
        userData.value!.photoUrl,
      );
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

  @override
  void onInit() {
    getUser();
    super.onInit();
  }
}
