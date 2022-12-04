import 'package:flutter/material.dart';
import '../../../../controller/post_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../services/firestore_methods.dart';
import '../../../../utils/utils.dart';

class PostImageWidget extends StatelessWidget {
  const PostImageWidget({
    super.key,
    required this.postSnapShot,
    required this.userController,
    required this.postController,
  });

  final Map<String, dynamic> postSnapShot;
  final UserController userController;
  final PostController postController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        await FirestoreMethods().likePost(
          postSnapShot['postId'] as String,
          userController.userData.value!.uid,
          (postSnapShot['likes'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList(),
        );

        postController.isLikeAnimating.value = true;
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.9,
            width: double.infinity,
            child: GestureDetector(
              onTap: () =>
                  showImageAlert(postSnapShot['postUrl'] as String, context),
              child: Image.network(
                postSnapShot['postUrl'] as String,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: Image.asset('assets/images/placeholder.png'),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) =>
                    Image.asset('assets/images/placeholder.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
