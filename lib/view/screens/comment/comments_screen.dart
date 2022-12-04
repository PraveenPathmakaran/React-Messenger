import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/colors.dart';
import '../../../controller/user_controller.dart';
import '../../../services/firestore_methods.dart';
import '../../../widgets/widgets.dart';
import 'widget/comment_card.dart';

class CommentsScreen extends StatelessWidget {
  CommentsScreen({super.key, required this.postSnapshotComment});
  final Map<String, dynamic> postSnapshotComment;
  final TextEditingController _commentController = TextEditingController();
  final UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return userController.userData.value == null
          ? const Center(
              child: circularProgressIndicator,
            )
          : Scaffold(
              backgroundColor: mobileBackgroundColor,
              appBar: const AppBarWidget(
                  title: 'Comments',
                  centerTitle: false,
                  backgroundColor: lightDarColor,
                  elevation: 0),
              body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postSnapshotComment['postId'] as String)
                    .collection('comments')
                    .orderBy(
                      'datePublished',
                      descending: true,
                    )
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularProgressIndicator;
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data!).docs.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CommentCard(
                      commentSnapShot: (snapshot.data!).docs[index],
                      postId: postSnapshotComment['postId'] as String,
                    ),
                  );
                },
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: lightDarColor,
                  ),
                  height: kToolbarHeight,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Row(
                    children: <Widget>[
                      CircleAvatarWidget(
                        networkImagePath:
                            userController.userData.value!.photoUrl,
                        radius: 18,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                                hintText:
                                    'Comment as ${userController.userData.value!.username}',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await FirestoreMethods().postComments(
                            postSnapshotComment['postId'] as String,
                            _commentController.text,
                            userController.userData.value!.uid,
                            userController.userData.value!.username,
                            userController.userData.value!.photoUrl,
                          );

                          _commentController.text = '';
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: const Text(
                            'Post',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
