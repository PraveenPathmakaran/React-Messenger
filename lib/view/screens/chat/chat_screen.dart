import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/chat_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    chatController.chat(friendUid);
    return Scaffold(
      appBar: AppBarWidget(
        title: friendName,
        centerTitle: false,
        backgroundColor: const Color(0XFF2A3942),
        elevation: 0,
      ),
      body: Obx(
        () {
          return StreamBuilder<QuerySnapshot<Object?>>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(chatController.chatDocId.value)
                .collection('messages')
                .orderBy('createdOn', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
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
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: chatController.isSender(
                                      snapshot.data!.docs[index]['uid']
                                          .toString())
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
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
          );
        },
      ),
    );
  }
}
