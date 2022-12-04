import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/colors.dart';
import '../../../controller/user_controller.dart';
import '../../../widgets/widgets.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userController.getUser();
    });
    return Obx(() {
      return userController.userData.value != null
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: lightDarColor,
                title: Text(userController.userData.value!.username),
                automaticallyImplyLeading: false,
                leading: ChatListAppBarRow(userController: userController),
              ),
              body: SingleChildScrollView(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  //OnlineList(),
                  kHeight10,
                  PreviousChat()
                ]),
              ),
            )
          : circularProgressIndicator;
    });
  }
}

class ChatListAppBarRow extends StatelessWidget {
  const ChatListAppBarRow({
    super.key,
    required this.userController,
  });

  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return userController.userData.value != null
        ? Row(
            children: <Widget>[
              kWidth15,
              Expanded(
                child: CircleAvatarWidget(
                    networkImagePath: userController.userData.value!.photoUrl),
              ),
            ],
          )
        : circularProgressIndicator;
  }
}

class OnlineList extends StatelessWidget {
  const OnlineList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CircleAvatarWidget(
              networkImagePath:
                  'https://www.tamiu.edu/newsinfo/images/student-life/campus-scenery.JPG',
              radius: 35,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 5,
        ),
      ),
    );
  }
}

class PreviousChat extends StatelessWidget {
  PreviousChat({super.key});
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return userController.userData.value != null
        ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firebaseFirestore.collection('user').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return circularProgressIndicator;
              }

              return snapshot.hasData
                  ? Flexible(
                      child: ListView.separated(
                        itemCount: snapshot.data!.docs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final Map<String, dynamic> userDetail =
                              snapshot.data!.docs[index].data();

                          //condition added for hide current user
                          return userDetail['uid'] ==
                                  userController.userData.value!.uid
                              ? const SizedBox()
                              : ListTile(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          ChatScreen(
                                              friendUid: userDetail['uid']
                                                  as String,
                                              friendName: userDetail['username']
                                                  as String,
                                              friendPhotoUrl:
                                                  userDetail['photoUrl']
                                                      as String),
                                    ),
                                  ),
                                  leading: CircleAvatarWidget(
                                    networkImagePath:
                                        userDetail['photoUrl'] as String,
                                    radius: 25,
                                  ),
                                  title: Text(userDetail['username'] as String),
                                  // trailing: const Icon(
                                  //   Icons.brightness_1,
                                  //   color: Colors.green,
                                  //   size: 10,
                                  // ),
                                );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return kHeight10;
                        },
                      ),
                    )
                  : const Center(
                      child: Text('Empty chat history'),
                    );
            },
          )
        : circularProgressIndicator;
  }
}
