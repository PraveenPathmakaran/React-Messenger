import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../const/colors.dart';
import '../../../../controller/friend_profile_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../chat/chat_screen.dart';
import 'follow_button.dart';
import 'follow_button_widget.dart';

class ProfileScreenButtons extends StatelessWidget {
  ProfileScreenButtons({
    super.key,
  });

  final UserController userController = Get.put(UserController());
  final FriendProfileScreenController friendProfileScreenController =
      Get.put(FriendProfileScreenController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: FollowButtonWidget(
            userController: userController,
            userUid:
                friendProfileScreenController.userData.value!['uid'] as String,
            friendProfileScreenController: friendProfileScreenController,
          ),
        ),
        Flexible(
          child: FollowButton(
            backgroundColor: mobileBackgroundColor,
            borderColor: Colors.white,
            text: 'Chat',
            textColor: Colors.white,
            function: () async {
              final QuerySnapshot<Map<String, dynamic>> userdata =
                  await FirebaseFirestore.instance
                      .collection('user')
                      .where('uid',
                          isEqualTo: friendProfileScreenController
                              .userData.value!['uid'] as String)
                      .get();
              final Map<String, dynamic> data = userdata.docs[0].data();
              Get.to(
                ChatScreen(
                  friendName: data['username'] as String,
                  friendUid: data['uid'] as String,
                  friendPhotoUrl: data['photoUrl'] as String,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
