import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/user_controller.dart';

class ChatController extends GetxController {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  final UserController userController = Get.put(UserController());

  Rxn<String> chatDocId = Rxn();
  TextEditingController textController = TextEditingController();

  void sendMessage(String message) {
    if (message == '') return;
    chats.doc(chatDocId.value).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': userController.userData.value!.uid,
      'message': message
    }).then((value) => textController.text = '');
  }

  bool isSender(String friend) {
    return friend == userController.userData.value!.uid;
  }

  Alignment getAlignment(friend) {
    if (friend == userController.userData.value!.uid) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  void chat(String friendUid) async {
    await chats
        .where('users', isEqualTo: {
          friendUid: null,
          userController.userData.value!.uid: null
        })
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            chatDocId.value = querySnapshot.docs.single.id;
          } else {
            chats.add({
              'users': {
                userController.userData.value!.uid: null,
                friendUid: null,
              }
            }).then((value) {
              chatDocId.value = value.id;
            });
          }
        })
        .catchError((error) {});
  }
}
