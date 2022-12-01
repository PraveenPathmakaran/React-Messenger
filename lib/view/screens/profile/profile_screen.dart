import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/profile_screen_controller.dart';
import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/controller/user_list_controller.dart';
import 'package:react_messenger/view/screens/chat/chat_screen.dart';
import 'package:react_messenger/view/screens/profile/widget/follow_button.dart';
import 'package:react_messenger/view/screens/profile/widget/follow_button_widget.dart';
import 'package:react_messenger/view/screens/profile/widget/profile_gridview.dart';
import 'package:react_messenger/view/screens/profile/widget/widgets.dart';
import 'package:react_messenger/view/screens/update/update_screen.dart';
import '../../../controller/user_controller.dart';
import '../../../widgets/widgets.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, this.userUid = '', this.currentUser = false});
  String userUid = '';
  bool currentUser = false;
  final ProfileScreenController profileScreenController =
      Get.put(ProfileScreenController());
  final UserController userController = Get.put(UserController());
  final UserListController userListController = Get.put(UserListController());
  @override
  Widget build(
    BuildContext context,
  ) {
    if (currentUser && userController.userData.value != null) {
      userUid = userController.userData.value!.uid;
    }
    double width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        profileScreenController.getData(context: context, uid: userUid);
      },
    );
    return Obx(
      () {
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
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatarWidget(
                                networkImagePath: profileScreenController
                                    .userData.value['photoUrl'],
                                radius: 80,
                              ),
                              currentUser
                                  ? IconButton(
                                      onPressed: () {
                                        Get.to(() => UpdateScreen(
                                              profileUrl:
                                                  profileScreenController
                                                      .userData
                                                      .value['photoUrl'],
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
                                  : const SizedBox(),
                            ],
                          ),
                          //Username
                          Container(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              profileScreenController
                                  .userData.value['username'],
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
                              buildStatColumn(
                                  profileScreenController.postLength,
                                  'Posts',
                                  width),
                              kWidth15,
                              GestureDetector(
                                onTap: () async {
                                  await filteredListGet('followers');
                                  Get.off(() => FilteredUsersList(
                                        title: 'Followers',
                                      ));
                                },
                                child: buildStatColumn(
                                    profileScreenController.followers.value,
                                    'Followers',
                                    width),
                              ),
                              kWidth15,
                              GestureDetector(
                                onTap: () async {
                                  await filteredListGet('following');
                                  Get.off(() => FilteredUsersList(
                                        title: 'Following',
                                      ));
                                },
                                child: buildStatColumn(
                                    profileScreenController.following.value,
                                    'Following',
                                    width),
                              ),
                              kWidth15,
                            ],
                          ),
                          //buttton
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: FollowButtonWidget(
                                  userController: userController,
                                  userUid: userUid,
                                  profileScreenController:
                                      profileScreenController,
                                ),
                              ),
                              currentUser
                                  ? const SizedBox()
                                  : Flexible(
                                      child: FollowButton(
                                        backgroundColor: mobileBackgroundColor,
                                        borderColor: Colors.white,
                                        text: 'Chat',
                                        textColor: Colors.white,
                                        function: () async {
                                          final userdata =
                                              await FirebaseFirestore.instance
                                                  .collection('user')
                                                  .where('uid',
                                                      isEqualTo: userUid)
                                                  .get();
                                          final data = userdata.docs[0].data();
                                          Get.to(
                                            ChatScreen(
                                              friendName: data['username'],
                                              friendUid: data['uid'],
                                              friendPhotoUrl: data['photoUrl'],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                          //Gridview
                          const Divider(),
                          ProfileGridviewWidget(
                            userUid: userUid,
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
    userListController.userId =
        await profileScreenController.userData.value['uid'];
    await userListController.usersListGet(dataName);
  }
}
