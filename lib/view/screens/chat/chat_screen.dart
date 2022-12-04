import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/chat_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../widgets/widgets.dart';
import 'widgets/chat_textfiled.dart';
import 'widgets/message_container.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(
      {super.key,
      required this.friendName,
      required this.friendUid,
      required this.friendPhotoUrl});
  final String friendUid;
  final String friendName;
  final String friendPhotoUrl;

  final ChatController chatController = Get.put(ChatController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    chatController.chatDocId.value = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userController.getUser();
      await chatController.chat(friendUid);
    });
    return Obx(
      () {
        if (chatController.chatDocId.value == null ||
            userController.userData.value == null) {
          return circularProgressIndicator;
        }
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 20,
            title: Row(
              children: <Widget>[
                CircleAvatarWidget(
                  networkImagePath: friendPhotoUrl,
                ),
                kWidth15,
                Text(friendName),
              ],
            ),
            centerTitle: false,
            backgroundColor: const Color(0XFF2A3942),
            elevation: 0,
          ),
          body: StreamBuilder<QuerySnapshot<Object?>>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(chatController.chatDocId.value)
                .collection('messages')
                .orderBy('createdOn', descending: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: circularProgressIndicator,
                );
              }

              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: chatController.isSender(
                                      snapshot.data!.docs[index]['uid']
                                          .toString())
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: MessageContainer(
                                    snapshot: snapshot,
                                    index: index,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    kHeight10,
                    MessageTextField(
                      chatController: chatController,
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
