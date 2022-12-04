import 'package:flutter/material.dart';
import '../../../../controller/friend_profile_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../services/firestore_methods.dart';
import 'follow_button.dart';

class FollowButtonWidget extends StatelessWidget {
  const FollowButtonWidget({
    super.key,
    required this.userController,
    required this.userUid,
    required this.friendProfileScreenController,
  });

  final UserController userController;
  final String userUid;
  final FriendProfileScreenController friendProfileScreenController;

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (friendProfileScreenController.isFollowing)
          FollowButton(
            function: () async {
              await FirestoreMethods().followUser(
                  userController.userData.value!.uid,
                  friendProfileScreenController.userData.value!['uid']
                      as String);

              friendProfileScreenController.isFollowing = false;
              friendProfileScreenController.followers.value--;
            },
            backgroundColor: Colors.white,
            borderColor: Colors.grey,
            text: 'Unfollow',
            textColor: Colors.black,
          )
        else
          FollowButton(
            function: () async {
              await FirestoreMethods().followUser(
                  userController.userData.value!.uid,
                  friendProfileScreenController.userData.value!['uid']
                      as String);

              friendProfileScreenController.isFollowing = true;
              friendProfileScreenController.followers.value++;
            },
            backgroundColor: Colors.blue,
            borderColor: Colors.blue,
            text: 'Follow',
            textColor: Colors.white,
          )
      ],
    );
  }
}
