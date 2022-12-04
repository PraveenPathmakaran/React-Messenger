import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../const/colors.dart';
import '../../../controller/friend_profile_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../controller/user_list_controller.dart';
import '../../../widgets/filtered_users_list.dart';
import '../../../widgets/widgets.dart';
import 'widget/profile_gridview.dart';
import 'widget/profile_screen_buttons.dart';
import 'widget/widgets.dart';

// ignore: must_be_immutable
class FriendProfileScreen extends StatelessWidget {
  FriendProfileScreen({super.key, required this.userId});
  String? userId;

  final FriendProfileScreenController friendProfileScreenController =
      Get.put(FriendProfileScreenController());
  final UserController userController = Get.put(UserController());
  final UserListController userListController = Get.put(UserListController());
  @override
  Widget build(
    BuildContext context,
  ) {
    final double width = MediaQuery.of(context).size.width;
    friendProfileScreenController.getData(context: context, uid: null);
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      await friendProfileScreenController.getData(
          context: context, uid: userId);
    });

    return Obx(
      () {
        return friendProfileScreenController.isLoading.value ||
                friendProfileScreenController.userData.value == null ||
                userController.userData.value == null
            ? circularProgressIndicator
            : Scaffold(
                appBar: AppBar(
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
                        children: <Widget>[
                          kHeight25,
                          //Circle Avatar
                          CircleAvatarWidget(
                            networkImagePath: friendProfileScreenController
                                .userData.value!['photoUrl'] as String,
                            radius: 80,
                          ),
                          //Username
                          Container(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              friendProfileScreenController
                                  .userData.value!['username'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          kHeight10,
                          //About
                          Container(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              friendProfileScreenController
                                  .userData.value!['bio'] as String,
                            ),
                          ),
                          kHeight25,
                          //follow following post row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              kWidth15,
                              buildStatColumn(
                                  friendProfileScreenController.postLength,
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
                                    friendProfileScreenController
                                        .followers.value,
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
                                    friendProfileScreenController
                                        .following.value,
                                    'Following',
                                    width),
                              ),
                              kWidth15,
                            ],
                          ),
                          //buttton

                          if (userController.userData.value!.uid == userId)
                            kHeight10
                          else
                            ProfileScreenButtons(),

                          //Gridview
                          const Divider(),
                          ProfileGridviewWidget(
                            userUid: friendProfileScreenController
                                .userData.value!['uid'] as String,
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
        await friendProfileScreenController.userData.value!['uid'] as String;
    await userListController.usersListGet(dataName);
  }
}
