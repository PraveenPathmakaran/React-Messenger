import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/const/const.dart';
import 'package:react_messenger/controller/profile_screen_controller.dart';
import 'package:react_messenger/controller/resources/auth_methods.dart';
import 'package:react_messenger/controller/resources/firestore_methods.dart';
import 'package:react_messenger/view/screens/login/login_screen.dart';

import 'package:react_messenger/utils/colors.dart';
import 'package:react_messenger/view/screens/profile/widget/follow_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.userUid});
  final String userUid;
  final ProfileScreenController profileScreenController =
      Get.put(ProfileScreenController());

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    double width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        profileScreenController.getData(context: context, uid: userUid);
      },
    );
    return Obx(() {
      return profileScreenController.isLoading.value ||
              profileScreenController.userData.value == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: width,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        kHeight25,
                        //Circle Avatar
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: const AssetImage(
                              'assets/images/circleProfile.png'),
                          foregroundImage: NetworkImage(profileScreenController
                              .userData.value['photoUrl']),
                          radius: 80,
                        ),
                        //Username
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            profileScreenController.userData.value['username'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                        kHeight10,
                        //About
                        // Container(
                        //   padding: const EdgeInsets.only(top: 1),
                        //   child: Text(
                        //     profileScreenController.userData.value['fullname'],
                        //   ),
                        // ),
                        kHeight25,

                        //follow following post row

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            kWidth15,
                            buildStatColumn(profileScreenController.postLength,
                                'Posts', width),
                            kWidth15,
                            buildStatColumn(profileScreenController.followers,
                                'Followers', width),
                            kWidth15,
                            buildStatColumn(profileScreenController.following,
                                'Following', width),
                            kWidth15,
                          ],
                        ),
                        //buttton
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == userUid
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
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              profileScreenController
                                                  .userData.value['uid']);

                                          profileScreenController.isFollowing =
                                              false;
                                          profileScreenController.followers--;
                                        },
                                        backgroundColor: Colors.white,
                                        borderColor: Colors.grey,
                                        text: 'Unfollow',
                                        textColor: Colors.black)
                                    : FollowButton(
                                        function: () async {
                                          await FirestoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              profileScreenController
                                                  .userData.value['uid']);

                                          profileScreenController.isFollowing =
                                              true;
                                          profileScreenController.followers++;
                                        },
                                        backgroundColor: Colors.blue,
                                        borderColor: Colors.blue,
                                        text: 'Follow',
                                        textColor: Colors.white)
                          ],
                        ),

                        //Gridview

                        const Divider(),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: userUid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 1.5,
                                        childAspectRatio: 1),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data! as dynamic).docs[index];
                                  return Image(
                                    image: NetworkImage(
                                      (snap.data()! as dynamic)['postUrl'],
                                    ),
                                    fit: BoxFit.cover,
                                  );
                                },
                              );
                            })
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }

  Column buildStatColumn(
    int num,
    String label,
    double width,
  ) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: width / 4,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
