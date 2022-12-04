import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/colors.dart';
import '../controller/friend_profile_controller.dart';
import '../controller/user_controller.dart';
import '../controller/user_list_controller.dart';
import '../view/screens/profile/friend_profile_screen.dart';
import 'widgets.dart';

class FilteredUsersList extends StatelessWidget {
  FilteredUsersList({super.key, required this.title});
  final String title;

  final UserListController userListController = Get.put(UserListController());
  final UserController userController = Get.put(UserController());
  final FriendProfileScreenController friendProfileScreenController =
      Get.put(FriendProfileScreenController());

  @override
  Widget build(BuildContext context) {
    return userListController.isLoading.value
        ? circularProgressIndicator
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(title),
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: ListView.builder(
                itemCount: userListController.userList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('user')
                          .doc(userListController.userList[index].uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.data == null) {
                          return kHeight10;
                        }
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) {
                                  return FriendProfileScreen(
                                    userId: snapshot.data!['uid'] as String,
                                  );
                                },
                              ),
                            );
                          },
                          leading: CircleAvatarWidget(
                            networkImagePath:
                                snapshot.data!['photoUrl'] as String,
                            radius: 25,
                          ),
                          title: Text(snapshot.data!['username'] as String),
                        );
                      });
                }),
          );
  }
}
