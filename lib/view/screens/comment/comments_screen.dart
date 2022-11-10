import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/const/const.dart';
import 'package:react_messenger/controller/resources/firestore_methods.dart';
import 'package:react_messenger/controller/resources/user_controller.dart';
import 'package:react_messenger/utils/colors.dart';
import 'widget/comment_card.dart';

class CommentsScreen extends StatelessWidget {
  final Map<String, dynamic> postSnapshotComment;

  CommentsScreen({super.key, required this.postSnapshotComment});
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
              appBar: AppBar(
                title: const Text('Comments'),
                centerTitle: false,
              ),
              body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postSnapshotComment['postId'])
                    .collection('comments')
                    .orderBy(
                      'datePublished',
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data!).docs.length,
                    itemBuilder: (context, index) => CommentCard(
                      commentSnapShot: (snapshot.data!).docs[index],
                      postId: postSnapshotComment['postId'],
                    ),
                  );
                },
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  height: kToolbarHeight,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: profilePlaceHolder,
                        foregroundImage: NetworkImage(
                            userController.userData.value!.photoUrl),
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
                            postSnapshotComment['postId'],
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
                            style: TextStyle(color: Colors.blueAccent),
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
