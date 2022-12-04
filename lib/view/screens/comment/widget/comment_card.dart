import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controller/user_controller.dart';
import '../../../../services/firestore_methods.dart';
import '../../../../widgets/widgets.dart';

class CommentCard extends StatelessWidget {
  CommentCard({super.key, required this.commentSnapShot, this.postId});
  final QueryDocumentSnapshot<Map<String, dynamic>> commentSnapShot;
  final String? postId;
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: <Widget>[
          CircleAvatarWidget(
            networkImagePath: commentSnapShot['profilePic'] as String,
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: commentSnapShot['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '\n${commentSnapShot['text']}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              if (commentSnapShot['uid'] == userController.userData.value!.uid)
                Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        await FirestoreMethods().deleteComment(
                          postId!,
                          commentSnapShot['commentId'] as String,
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                )
              else
                const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat.yMMMd().format(
                      (commentSnapShot['datePublished'] as Timestamp).toDate()),
                  style: const TextStyle(fontSize: 7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
