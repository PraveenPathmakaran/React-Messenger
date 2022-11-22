import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/chat_controller.dart';
import 'package:react_messenger/const/colors.dart';

import '../../../widgets/widgets.dart';

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
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, top: 20),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: chatController.isSender(snapshot
                                              .data!.docs[index]['uid']
                                              .toString())
                                          ? const Color(0xFF202C33)
                                          : const Color(0xFF005C4B),
                                      borderRadius: chatController.isSender(
                                              snapshot.data!.docs[index]['uid']
                                                  .toString())
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30))
                                          : const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                              bottomLeft: Radius.circular(30)),
                                    ),
                                    child: Text(
                                        snapshot.data!.docs[index]['message']),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    kHeight10,
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: lightDarColor,
                        border: InputBorder.none,
                        hintText: 'Write something',
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.send_sharp,
                            size: 30,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => chatController
                              .sendMessage(chatController.textController.text),
                        ),
                      ),
                      controller: chatController.textController,
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
