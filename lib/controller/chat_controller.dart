import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';

class ChatController extends GetxController {
  CollectionReference<Object?> chats =
      FirebaseFirestore.instance.collection('chats');

  final UserController userController = Get.put(UserController());

  Rxn<String> chatDocId = Rxn<String>();
  TextEditingController textController = TextEditingController();

  void sendMessage(String message) {
    if (message == '') {
      return;
    }
    chats.doc(chatDocId.value).collection('messages').add(<String, dynamic>{
      'createdOn': FieldValue.serverTimestamp(),
      'uid': userController.userData.value!.uid,
      'message': message
    }).then((DocumentReference<Map<String, dynamic>> value) =>
        textController.text = '');
  }

  bool isSender(String friend) {
    return friend == userController.userData.value!.uid;
  }

  Alignment getAlignment(String friend) {
    if (friend == userController.userData.value!.uid) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  Future<void> chat(String friendUid) async {
    await chats
        .where('users', isEqualTo: <String, dynamic>{
          friendUid: null,
          userController.userData.value!.uid: null
        })
        .limit(1)
        .get()
        .then((QuerySnapshot<Object?> querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            chatDocId.value = querySnapshot.docs.single.id;
          } else {
            chats.add(<String, dynamic>{
              'users': <String, dynamic>{
                userController.userData.value!.uid: null,
                friendUid: null,
              }
            }).then((DocumentReference<Object?> value) {
              chatDocId.value = value.id;
            });
          }
        })
        .catchError((dynamic error) {});
  }
}
