import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:react_messenger/controller/post_controller.dart';
import 'package:react_messenger/controller/resources/firestore_methods.dart';
import 'package:react_messenger/view/screens/comment/comments_screen.dart';
import 'package:react_messenger/utils/colors.dart';

import '../../../../const/const.dart';
import '../../../../controller/resources/user_controller.dart';

class PostCard extends StatelessWidget {
  PostCard({super.key, required this.postSnapShot});
  final Map<String, dynamic> postSnapShot;
  final PostController postController = Get.put(PostController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return userController.userData.value == null
          ? const SizedBox()
          : Container(
              color: mobileBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  //Header Section
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                            .copyWith(right: 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          onForegroundImageError: (exception, stackTrace) =>
                              profilePlaceHolder,
                          radius: 16,
                          backgroundImage: profilePlaceHolder,
                          foregroundImage: NetworkImage(
                            postSnapShot['profImage'],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  postSnapShot['username'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          child: Image.network(
                            postSnapShot['postUrl'],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
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
                        // AnimatedOpacity(
                        //   duration: const Duration(milliseconds: 200),
                        //   opacity: postController.isLikeAnimating.value ? 1 : 0,
                        //   child: LikeAnimation(
                        //     isAnimating: postController.isLikeAnimating.value,
                        //     duration: const Duration(milliseconds: 400),
                        //     onEnd: () {
                        //       postController.isLikeAnimating.value = false;
                        //     },
                        //     child: const Icon(
                        //       Icons.favorite,
                        //       color: Colors.white,
                        //       size: 120,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  //Like comment section
                  kHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    )),
                          // LikeAnimation(
                          //   isAnimating: snap1['likes']
                          //       .contains(postController.userData.value.uid),
                          //   smallLike: true,
                          //   child: IconButton(
                          //       onPressed: () async {
                          //         await FirestoreMethods().likePost(
                          //           snap1['postId'],
                          //           postController.userData.value.uid,
                          //           snap1['likes'],
                          //         );
                          //       },
                          //       icon: snap1['likes']
                          //               .contains(postController.userData.value.uid)
                          //           ? const Icon(
                          //               Icons.favorite,
                          //               color: Colors.red,
                          //             )
                          //           : const Icon(
                          //               Icons.favorite_outline,
                          //               color: Colors.white,
                          //             )),
                          // ),

                          Text('${postSnapShot['likes'].length}'),
                        ],
                      ),
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
                          //find comment count
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('');
                                }
                                return Text(
                                  (snapshot.data!.docs.isNotEmpty
                                          ? snapshot.data!.docs.length
                                          : '')
                                      .toString(),
                                );
                              })
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.report,
                        ),
                      ),
                    ],
                  ),
                  //Description and number of comments

                  Column(children: [
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: '${postSnapShot['description']}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat.yMMMMd()
                                .format(postSnapShot['datePublished'].toDate()),
                            style: const TextStyle(
                                fontSize: 12, color: secondaryColor),
                          ),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
            );
    });
  }
}
