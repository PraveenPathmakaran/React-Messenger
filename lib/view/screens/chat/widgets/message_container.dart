import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controller/chat_controller.dart';

class MessageContainer extends StatelessWidget {
  MessageContainer({super.key, required this.snapshot, required this.index});
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final int index;
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    final String month = DateFormat.MMMd()
        .format(snapshot.data!.docs[index]['createdOn'].toDate());
    final String time = DateFormat.jm()
        .format(snapshot.data!.docs[index]['createdOn'].toDate());

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: chatController
                .isSender(snapshot.data!.docs[index]['uid'].toString())
            ? const Color(0xFF202C33)
            : const Color(0xFF005C4B),
        borderRadius: chatController
                .isSender(snapshot.data!.docs[index]['uid'].toString())
            ? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.data!.docs[index]['message'],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "$month $time",
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
