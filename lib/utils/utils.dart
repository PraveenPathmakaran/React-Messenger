import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  final XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return file.readAsBytes();
  }
  final ByteData byteData =
      await rootBundle.load('assets/images/defaultProfile.jpg');

  final Uint8List bytes = byteData.buffer.asUint8List();
  return bytes;
}

Future<Uint8List> imageGet() async {
  final ByteData bytes =
      await rootBundle.load('assets/images/defaultProfile.jpg');
  final Uint8List list = bytes.buffer.asUint8List();
  return list;
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
