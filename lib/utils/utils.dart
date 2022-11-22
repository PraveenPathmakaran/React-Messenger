import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<String> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  try {
    XFile? file = await imagePicker.pickImage(source: source, imageQuality: 10);

    if (file != null) {
      String imagePath = await cropImage(imageFile: file.path);
      return imagePath;
    }
  } catch (e) {
    return e.toString();
  }

  return 'No image selected';
}

Future<String> cropImage({required String imageFile}) async {
  CroppedFile? croppedFile =
      await ImageCropper().cropImage(sourcePath: imageFile);
  if (croppedFile == null) return 'No image selected';
  return croppedFile.path;
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

showImageAlert(String path, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => SizedBox(
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        actions: [
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
