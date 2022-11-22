import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:react_messenger/controller/post_controller.dart';
import 'package:react_messenger/services/firestore_methods.dart';
import 'package:react_messenger/utils/utils.dart';
import 'package:react_messenger/view/screens/comment/comments_screen.dart';
import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/view/screens/profile/profile_screen.dart';
import '../../../../controller/user_controller.dart';
import '../../../../widgets/widgets.dart';

class PostCard extends StatelessWidget {
  PostCard({super.key, required this.postSnapShot});

  final Map<String, dynamic> postSnapShot;
  final PostController postController = Get.put(PostController());
  final UserController userController = Get.put(UserController());
  Map<String, dynamic> currentUserMap = {};

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return userController.userData.value == null || currentUserMap == {}
          ? const SizedBox()
          : Container(
              color: lightDarColor,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  //Header Section
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Row(
                      children: [
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('user')
                                .where('uid', isEqualTo: postSnapShot['uid'])
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatarWidget(
                                  networkImagePath:
                                      snapshot.data!.docs[0].data()['photoUrl'],
                                  radius: 16,
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          userUid: postSnapShot['uid']),
                                    ),
                                  ),
                                  child: FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('user')
                                          .where('uid',
                                              isEqualTo: postSnapShot['uid'])
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data!.docs[0]
                                                .data()['username'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                        postSnapShot['uid'] ==
                                userController.userData.value!.uid
                            ? IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: ListView(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shrinkWrap: true,
                                        children: [
                                          InkWell(
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 16),
                                              child: Text('Delete'),
                                            ),
                                            onTap: () {
                                              FirestoreMethods().deletePost(
                                                postSnapShot['postId'],
                                              );
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.more_vert),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  //Image Section
                  kHeight10,
                  GestureDetector(
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
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () => showImageAlert(
                                postSnapShot['postUrl'], context),
                            child: Image.network(
                              postSnapShot['postUrl'],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: Image.asset(
                                      "assets/images/placeholder.png"),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/placeholder.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Like comment section
                  kHeight10,
                  Padding(
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
                                  icon: postSnapShot['likes'].contains(
                                          userController.userData.value!.uid)
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
                            Text(
                                'Liked by ${postSnapShot['likes'].length} people'),
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
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
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
                              DateFormat.yMMMMd().format(
                                  postSnapShot['datePublished'].toDate()),
                              style: const TextStyle(
                                  fontSize: 14, color: secondaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
