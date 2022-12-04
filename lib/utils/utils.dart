import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> pickImage(ImageSource source) async {
  await Permission.camera.request();
  if (await Permission.camera.status.isDenied) {
    Get.snackbar('Error', 'Camera Permission denied');
    return 'No image selected';
  }
  final ImagePicker imagePicker = ImagePicker();
  try {
    final XFile? file =
        await imagePicker.pickImage(source: source, imageQuality: 10);

    if (file != null) {
      final String imagePath = await cropImage(imageFile: file.path);
      return imagePath;
    }
  } catch (e) {
    log(e.toString());
    return e.toString();
  }

  return 'No image selected';
}

Future<String> cropImage({required String imageFile}) async {
  try {
    final CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: imageFile);
    if (croppedFile == null) {
      return 'No image selected';
    }
    return croppedFile.path;
  } catch (e) {
    Get.snackbar('Error', 'Image Error');
  }
  return '';
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

void showImageAlert(String path, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => SizedBox(
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ],
        backgroundColor: Colors.transparent,
        content: Image.network(
          path,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
