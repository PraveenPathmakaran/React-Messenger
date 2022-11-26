import 'package:flutter/material.dart';
import '../../../../controller/post_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../services/firestore_methods.dart';
import '../../../../utils/utils.dart';

class PostImageWidget extends StatelessWidget {
  const PostImageWidget({
    Key? key,
    required this.postSnapShot,
    required this.userController,
    required this.postController,
  }) : super(key: key);

  final Map<String, dynamic> postSnapShot;
  final UserController userController;
  final PostController postController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        await FirestoreMethods().likePost(
          postSnapShot['postId'],
          userController.userData.value!.uid,
          postSnapShot['likes'],
        );

        postController.isLikeAnimating.value = true;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            //height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: GestureDetector(
              onTap: () => showImageAlert(postSnapShot['postUrl'], context),
              child: Image.network(
                postSnapShot['postUrl'],
                fit: BoxFit.fitHeight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Image.asset("assets/images/placeholder.png"),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/placeholder.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
