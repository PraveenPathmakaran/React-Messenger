import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../const/const.dart';
import '../../../controller/addpost_controller.dart';
import '../../../controller/user_controller.dart';

import '../../../widgets/widgets.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});
  final TextEditingController textController = TextEditingController();
  final AddPostController addPostController = Get.put(AddPostController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    userController.userData.value = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userController.getUser();
    });
    final double height = MediaQuery.of(context).size.width * 60 / 100;
    final double widht = MediaQuery.of(context).size.width * 90 / 100;
    return Obx(
      () {
        return addPostController.isLoading.value
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    addPostController.progress.value.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const Text(
                    'Upload progress',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ))
            : addPostController.filePath.value == null ||
                    addPostController.filePath.value == 'No image selected'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => addPostController.selectImage(context),
                        child: Lottie.asset(
                          'assets/upload.json',
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            addPostController.selectImage(context);
                          },
                          icon: const Icon(
                            Icons.upload,
                            size: 30,
                          )),
                      const Text(
                        'Upload',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  )
                : Scaffold(
                    body: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            //image container

                            Container(
                              height: height,
                              width: widht,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                      File(addPostController.filePath.value!)),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            //description

                            SizedBox(
                              width: widht,
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: textController,
                                decoration: const InputDecoration(
                                  hintText: 'Write Something here',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            //add post button
                            kHeight25,
                            ElevatedButton(
                              style: buttonStyle.copyWith(
                                minimumSize:
                                    MaterialStateProperty.all(Size(widht, 45)),
                              ),
                              onPressed: () async {
                                await addPostController.postImage(
                                    context, textController.text);
                                addPostController.isLoading.value
                                    ? const SizedBox()
                                    : textController.clear();
                              },
                              child: const Text('Add Post'),
                            ),
                            kHeight25,
                            ElevatedButton(
                              style: buttonStyle.copyWith(
                                minimumSize:
                                    MaterialStateProperty.all(Size(widht, 45)),
                              ),
                              onPressed: () {
                                addPostController.filePath.value = null;
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
      },
    );
  }
}
