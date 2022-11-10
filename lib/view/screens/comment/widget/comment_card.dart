import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:react_messenger/const/const.dart';
import 'package:react_messenger/controller/resources/user_controller.dart';

import '../../../../controller/resources/firestore_methods.dart';

class CommentCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> commentSnapShot;
  final String? postId;
  final UserController userController = Get.put(UserController());
  CommentCard({super.key, required this.commentSnapShot, this.postId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: profilePlaceHolder,
            foregroundImage: NetworkImage(commentSnapShot['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: commentSnapShot['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '    ${commentSnapShot['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(commentSnapShot['datePublished'].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          commentSnapShot['uid'] == userController.userData.value!.uid
              ? IconButton(
                  onPressed: () async {
                    await FirestoreMethods().deleteComment(
                      postId!,
                      commentSnapShot['commentId'],
                    );
                  },
                  icon: const Icon(Icons.delete),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
