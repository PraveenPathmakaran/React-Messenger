import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/search_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../widgets/widgets.dart';
import '../../profile/friend_profile_screen.dart';

class SearchUserList extends StatelessWidget {
  SearchUserList({
    super.key,
    required this.searchController,
  });
  final SearchController searchController;
  final UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return FriendProfileScreen(
            userId: searchController.postDocumentList.value!.docs[0]
                .data()['uid'] as String,
          );
        }));
      },
      child: ListTile(
        leading: CircleAvatarWidget(
            networkImagePath: searchController.postDocumentList.value!.docs[0]
                .data()['photoUrl'] as String),
        title: Text(searchController.postDocumentList.value!.docs[0]
            .data()['username'] as String),
      ),
    );
  }
}
