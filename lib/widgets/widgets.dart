import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/colors.dart';
import '../controller/user_controller.dart';
import '../controller/user_list_controller.dart';
import '../view/screens/home/home_screen.dart';
import '../view/screens/profile/profile_screen.dart';

const Widget kHeight50 = SizedBox(
  height: 50,
);
const Widget kHeight25 = SizedBox(
  height: 25,
);
const Widget kHeight10 = SizedBox(
  height: 10,
);
const Widget kWidth15 = SizedBox(
  width: 15,
);
const Widget circularProgressIndicator = Center(
  child: CircularProgressIndicator(
    color: Colors.white,
  ),
);

const AssetImage profilePlaceHolder =
    AssetImage('assets/images/circleProfile.png');

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    required this.centerTitle,
    required this.backgroundColor,
    required this.elevation,
  });
  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

//circle avatar
class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget(
      {super.key, required this.networkImagePath, this.radius = 20});

  final String networkImagePath;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      onForegroundImageError: (Object exception, StackTrace? stackTrace) =>
          profilePlaceHolder,
      backgroundImage: profilePlaceHolder,
      foregroundImage: NetworkImage(
        networkImagePath,
      ),
    );
  }
}

class FilteredUsersList extends StatelessWidget {
  FilteredUsersList({super.key, required this.title});
  final String title;

  final UserListController userListController = Get.put(UserListController());
  final UserController userController = Get.put(UserController());

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
                onPressed: () => Get.offAll(() => const MobileScreenLayout()),
              ),
            ),
            body: ListView.builder(
                itemCount: userListController.userList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
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
                            final bool currentUser = snapshot.data!['uid'] ==
                                userController.userData.value!.uid;
                            Get.to(() => ProfileScreen(
                                  userUid: snapshot.data!['uid'],
                                  currentUser: currentUser,
                                ));
                          },
                          leading: CircleAvatarWidget(
                            networkImagePath: snapshot.data!['photoUrl'],
                            radius: 25,
                          ),
                          title: Text(snapshot.data!['username']),
                        );
                      });
                }),
          );
  }
}
