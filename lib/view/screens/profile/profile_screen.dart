import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/profile_screen_controller.dart';
import 'package:react_messenger/services/auth_methods.dart';
import 'package:react_messenger/services/firestore_methods.dart';
import 'package:react_messenger/view/screens/feed/widget/post_card.dart';
import 'package:react_messenger/view/screens/login/login_screen.dart';

import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/view/screens/profile/widget/follow_button.dart';
import 'package:react_messenger/view/screens/update/update_screen.dart';

import '../../../controller/user_controller.dart';
import '../../../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, this.userUid = '', this.currentUser = false});
  String userUid = '';
  bool currentUser = false;
  final ProfileScreenController profileScreenController =
      Get.put(ProfileScreenController());
  final UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    if (currentUser && userController.userData.value != null) {
      userUid = userController.userData.value!.uid;
    }

    double width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        profileScreenController.getData(context: context, uid: userUid);
      },
    );
    return Obx(() {
      return profileScreenController.isLoading.value ||
              profileScreenController.userData.value == null ||
              userController.userData.value == null ||
              userUid == ''
          ? circularProgressIndicator
          : Scaffold(
              appBar: const AppBarWidget(
                title: '',
                centerTitle: false,
                backgroundColor: mobileBackgroundColor,
                elevation: 0,
              ),
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

                        Stack(alignment: Alignment.bottomRight, children: [
                          CircleAvatarWidget(
                            networkImagePath: profileScreenController
                                .userData.value['photoUrl'],
                            radius: 80,
                          ),
                          currentUser
                              ? IconButton(
                                  onPressed: () {
                                    Get.to(() => UpdateScreen(
                                          profileUrl: profileScreenController
                                              .userData.value['photoUrl'],
                                          username: profileScreenController
                                              .userData.value['username'],
                                          bio: profileScreenController
                                              .userData.value['bio'],
                                          userId: userUid,
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.edit_note_outlined,
                                    size: 40,
                                  ))
                              : const SizedBox()
                        ]),

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
                        Container(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            profileScreenController.userData.value['bio'],
                          ),
                        ),
                        kHeight25,

                        //follow following post row

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            kWidth15,
                            buildStatColumn(profileScreenController.postLength,
                                'Posts', width),
                            kWidth15,
                            buildStatColumn(
                                profileScreenController.followers.value,
                                'Followers',
                                width),
                            kWidth15,
                            buildStatColumn(
                                profileScreenController.following.value,
                                'Following',
                                width),
                            kWidth15,
                          ],
                        ),
                        //buttton
                        Row(
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
                                              userController
                                                  .userData.value!.uid,
                                              profileScreenController
                                                  .userData.value['uid']);

                                          profileScreenController.isFollowing =
                                              false;
                                          profileScreenController
                                              .followers.value--;
                                        },
                                        backgroundColor: Colors.white,
                                        borderColor: Colors.grey,
                                        text: 'Unfollow',
                                        textColor: Colors.black)
                                    : FollowButton(
                                        function: () async {
                                          await FirestoreMethods().followUser(
                                              userController
                                                  .userData.value!.uid,
                                              profileScreenController
                                                  .userData.value['uid']);

                                          profileScreenController.isFollowing =
                                              true;
                                          profileScreenController
                                              .followers.value++;
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
                                return circularProgressIndicator;
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
                                  return GestureDetector(
                                    //this detector for post list view current user
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileUsersFeed(
                                                userData: userUid,
                                              )),
                                    ),
                                    child: Image(
                                      image: NetworkImage(
                                        (snap.data()! as dynamic)['postUrl'],
                                      ),
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: Image.asset(
                                              "assets/images/placeholder.png"),
                                        );
                                      },
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Image.asset(
                                              'assets/images/placeholder.png'),
                                    ),
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

class ProfileUsersFeed extends StatelessWidget {
  ProfileUsersFeed({super.key, required this.userData});
  final ScrollController scrollController = ScrollController();
  final String userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: '',
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: userData)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgressIndicator;
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    postSnapShot: snapshot.data!.docs[index].data(),
                  ),
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 2,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
