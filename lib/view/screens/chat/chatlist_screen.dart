import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/user_controller.dart';
import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/view/screens/chat/chat_screen.dart';
import '../../../widgets/widgets.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
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
    Key? key,
    required this.userController,
  }) : super(key: key);

  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        kWidth15,
        Expanded(
          child: CircleAvatarWidget(
              networkImagePath: userController.userData.value!.photoUrl),
        ),
      ],
    );
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
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CircleAvatarWidget(
              networkImagePath:
                  'https://www.tamiu.edu/newsinfo/images/student-life/campus-scenery.JPG',
              radius: 35,
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
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
    return StreamBuilder(
      stream: firebaseFirestore.collection('user').snapshots(),
      builder: (context,
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
                  itemBuilder: (context, index) {
                    Map<String, dynamic> userDetail =
                        snapshot.data!.docs[index].data();

                    //condition added for hide current user
                    return userDetail['uid'] ==
                            userController.userData.value!.uid
                        ? const SizedBox()
                        : ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    friendUid: userDetail['uid'],
                                    friendName: userDetail['username'],
                                    friendPhotoUrl: userDetail['photoUrl']),
                              ),
                            ),
                            leading: CircleAvatarWidget(
                              networkImagePath: userDetail['photoUrl'],
                              radius: 25,
                            ),
                            title: Text(userDetail['username']),
                            // trailing: const Icon(
                            //   Icons.brightness_1,
                            //   color: Colors.green,
                            //   size: 10,
                            // ),
                          );
                  },
                  separatorBuilder: (context, index) {
                    return kHeight10;
                  },
                ),
              )
            : const Center(
                child: Text('Empty chat history'),
              );
      },
    );
  }
}
