import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../const/colors.dart';
import '../../../controller/friend_profile_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../controller/user_list_controller.dart';
import '../../../services/auth_methods.dart';
import '../../../widgets/filtered_users_list.dart';
import '../../../widgets/widgets.dart';
import '../drawer/drawer.dart';
import '../login/login_screen.dart';
import '../update/update_screen.dart';
import 'widget/follow_button.dart';
import 'widget/profile_gridview.dart';
import 'widget/widgets.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserController userController = Get.put(UserController());
  final UserListController userListController = Get.put(UserListController());
  final FriendProfileScreenController friendProfileScreenController =
      Get.put(FriendProfileScreenController());
  @override
  Widget build(
    BuildContext context,
  ) {
    userController.userData.value = null;
    friendProfileScreenController.getData(context: context, uid: null);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userController.getUser();
      await friendProfileScreenController.getData(
          context: context, uid: userController.userData.value!.uid);
    });

    final double width = MediaQuery.of(context).size.width;

    return Obx(
      () {
        return userController.userData.value == null
            ? circularProgressIndicator
            : Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  backgroundColor: mobileBackgroundColor,
                  elevation: 0,
                ),
                drawer: const Drawer(
                  width: 250,
                  backgroundColor: mobileBackgroundColor,
                  child: DrawerContent(),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      width: width,
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          kHeight25,
                          //Circle Avatar
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: <Widget>[
                              CircleAvatarWidget(
                                networkImagePath:
                                    userController.userData.value!.photoUrl,
                                radius: 80,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.to(() => UpdateScreen(
                                        profileUrl: userController
                                            .userData.value!.photoUrl,
                                        username: userController
                                            .userData.value!.username,
                                        bio: userController.userData.value!.bio,
                                        userId: userController
                                            .userData.value!.uid));
                                  },
                                  icon: const Icon(
                                    Icons.edit_note_outlined,
                                    size: 40,
                                  ))
                            ],
                          ),
                          //Username
                          Container(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              userController.userData.value!.username,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          kHeight10,
                          //About
                          Container(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              userController.userData.value!.bio,
                            ),
                          ),
                          kHeight25,
                          //follow following post row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              kWidth15,
                              FutureBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  future: FirebaseFirestore.instance
                                      .collection('posts')
                                      .where('uid',
                                          isEqualTo: userController
                                              .userData.value!.uid)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.data == null) {
                                      return circularProgressIndicator;
                                    }
                                    return buildStatColumn(
                                        snapshot.data!.docs.length,
                                        'Posts',
                                        width);
                                  }),
                              kWidth15,
                              GestureDetector(
                                onTap: () async {
                                  await filteredListGet('followers');
                                  Get.to(() => FilteredUsersList(
                                        title: 'Followers',
                                      ));
                                },
                                child: buildStatColumn(
                                    userController
                                        .userData.value!.followers.length,
                                    'Followers',
                                    width),
                              ),
                              kWidth15,
                              GestureDetector(
                                onTap: () async {
                                  await filteredListGet('following');
                                  Get.to(() => FilteredUsersList(
                                        title: 'Following',
                                      ));
                                },
                                child: buildStatColumn(
                                    userController
                                        .userData.value!.following.length,
                                    'Following',
                                    width),
                              ),
                              kWidth15,
                            ],
                          ),
                          FollowButton(
                              function: () async {
                                await AuthMethods().signOut().then(
                                    (void value) =>
                                        Get.offAll(() => LoginScreen()));

                                userController.userData.value = null;
                              },
                              backgroundColor: mobileBackgroundColor,
                              borderColor: Colors.grey,
                              text: 'Sign Out',
                              textColor: primaryColor),

                          //Gridview
                          const Divider(),
                          ProfileGridviewWidget(
                            userUid: userController.userData.value!.uid,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Future<void> filteredListGet(String dataName) async {
    userListController.userList.clear();
    userListController.userId = userController.userData.value!.uid;
    await userListController.usersListGet(dataName);
  }
}
