import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/controller/signup_controller.dart';
import '../../../const/const.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../widgets/text_field_input.dart';

class UpdateScreen extends StatelessWidget {
  UpdateScreen({
    super.key,
    required this.profileUrl,
    required this.username,
    required this.bio,
    required this.userId,
  });
  final SignUpController signUpController = Get.put(SignUpController());
  final String profileUrl;
  final String username;
  final String bio;
  final String userId;
  @override
  Widget build(BuildContext context) {
    signUpController.usernameController.text = username;
    signUpController.bioController.text = bio;
    return Scaffold(
      appBar: const AppBarWidget(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          elevation: 0,
          title: ''),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //profile image
                  Obx(() {
                    return Stack(
                      children: <Widget>[
                        if (signUpController.image.value != null)
                          CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                FileImage(File(signUpController.image.value!)),
                            backgroundColor: Colors.transparent,
                          )
                        else
                          GestureDetector(
                            onTap: () async {
                              signUpController.image.value =
                                  await pickImage(ImageSource.gallery);
                            },
                            child: CircleAvatarWidget(
                              networkImagePath: profileUrl,
                              radius: 64,
                            ),
                          ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        )
                      ],
                    );
                  }),

                  kHeight25,

                  TextFieldInput(
                    textEditingController: signUpController.usernameController,
                    hintText: 'Username',
                    textInputType: TextInputType.text,
                    label: 'Username',
                    icon: Icons.manage_accounts_rounded,
                  ),
                  kHeight25,
                  TextFieldInput(
                    textEditingController: signUpController.bioController,
                    hintText: 'Bio',
                    textInputType: TextInputType.text,
                    label: 'Bio',
                    icon: Icons.note,
                  ),

                  kHeight25,
                  //button login

                  ElevatedButton(
                      onPressed: () async {
                        await signUpController.updateUserController(
                            userId, context);
                      },
                      style: buttonStyle,
                      child: Obx(() {
                        return signUpController.isLoading.value
                            ? circularProgressIndicator
                            : const Text('Update');
                      })),
                  kHeight25,
                  //transition to signing up
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
