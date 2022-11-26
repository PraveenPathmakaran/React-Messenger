import 'package:flutter/material.dart';

import '../../../../const/colors.dart';
import '../../../../controller/chat_controller.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    Key? key,
    required this.chatController,
  }) : super(key: key);

  final ChatController chatController;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
          onPressed: () =>
              chatController.sendMessage(chatController.textController.text),
        ),
      ),
      controller: chatController.textController,
    );
  }
}
