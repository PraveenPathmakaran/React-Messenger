import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../const/colors.dart';
import '../../../../controller/user_controller.dart';
import '../../../../services/firestore_methods.dart';
import '../../../../widgets/widgets.dart';
import '../../comment/comments_screen.dart';

class PostLikeCommentWidget extends StatelessWidget {
  const PostLikeCommentWidget({
    Key? key,
    required this.postSnapShot,
    required this.userController,
  }) : super(key: key);

  final Map<String, dynamic> postSnapShot;
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //like column
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        postSnapShot['postId'],
                        userController.userData.value!.uid,
                        postSnapShot['likes'],
                      );
                    },
                    icon: postSnapShot['likes']
                            .contains(userController.userData.value!.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
              //like count
              Text('Liked by ${postSnapShot['likes'].length} people'),
              kHeight10,

              //description

              Text(
                '${postSnapShot['description']}'.length > 30
                    ? '${'${postSnapShot['description']}'.substring(0, 20)}...'
                    : '${postSnapShot['description']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            postSnapshotComment: postSnapShot,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.comment_outlined,
                    ),
                  ),
                ],
              ),
              // find comment count
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postSnapShot['postId'])
                    .collection('comments')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }

                  return Text(
                    '${(snapshot.data!.docs.length).toString()} comments',
                  );
                },
              ),

              kHeight10,
              Text(
                DateFormat.yMMMMd()
                    .format(postSnapShot['datePublished'].toDate()),
                style: const TextStyle(fontSize: 14, color: secondaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
