import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../const/colors.dart';
import '../../../../controller/post_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../widgets/widgets.dart';
import 'post_image_widget.dart';
import 'post_like_comment.dart';
import 'postscreen_header.dart';

class PostCard extends StatelessWidget {
  PostCard({super.key, required this.postSnapShot});
  final Map<String, dynamic> postSnapShot;
  final PostController postController = Get.put(PostController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return userController.userData.value == null ||
                postSnapShot['status'] != true
            ? const SizedBox()
            : Container(
                color: lightDarColor,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    //Header Section
                    PostHeaderSection(postSnapShot: postSnapShot),
                    //Image Section
                    kHeight10,
                    PostImageWidget(
                      postSnapShot: postSnapShot,
                      userController: userController,
                      postController: postController,
                    ),
                    //Like comment section
                    PostLikeCommentWidget(
                      postSnapShot: postSnapShot,
                      userController: userController,
                    ),
                  ],
                ),
              );
      },
    );
  }
}
