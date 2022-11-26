import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/post_controller.dart';
import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/view/screens/feed/widget/post_image_widget.dart';
import 'package:react_messenger/view/screens/feed/widget/post_like_comment.dart';
import 'package:react_messenger/view/screens/feed/widget/postscreen_header.dart';
import '../../../../controller/user_controller.dart';
import '../../../../widgets/widgets.dart';

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
                  children: [
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
                    kHeight10,
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
