import 'package:flutter/material.dart';
import 'package:react_messenger/view/screens/profile/widget/follow_button.dart';

import '../../../../const/colors.dart';
import '../../../../controller/profile_screen_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../services/auth_methods.dart';
import '../../../../services/firestore_methods.dart';
import '../../login/login_screen.dart';

class FollowButtonWidget extends StatelessWidget {
  const FollowButtonWidget({
    Key? key,
    required this.userController,
    required this.userUid,
    required this.profileScreenController,
  }) : super(key: key);

  final UserController userController;
  final String userUid;
  final ProfileScreenController profileScreenController;

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        userController.userData.value!.uid == userUid
            ? FollowButton(
                function: () async {
                  await AuthMethods().signOut();
                  if (!mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                backgroundColor: mobileBackgroundColor,
                borderColor: Colors.grey,
                text: 'Sign Out',
                textColor: primaryColor)
            : profileScreenController.isFollowing
                ? FollowButton(
                    function: () async {
                      await FirestoreMethods().followUser(
                          userController.userData.value!.uid,
                          profileScreenController.userData.value['uid']);

                      profileScreenController.isFollowing = false;
                      profileScreenController.followers.value--;
                    },
                    backgroundColor: Colors.white,
                    borderColor: Colors.grey,
                    text: 'Unfollow',
                    textColor: Colors.black,
                  )
                : FollowButton(
                    function: () async {
                      await FirestoreMethods().followUser(
                          userController.userData.value!.uid,
                          profileScreenController.userData.value['uid']);

                      profileScreenController.isFollowing = true;
                      profileScreenController.followers.value++;
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
