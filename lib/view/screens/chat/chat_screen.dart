import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class Messages {
  String text;
  DateTime dateTime;
  bool isSentbyme;

  Messages(
      {required this.text, required this.dateTime, required this.isSentbyme});
}

List<Messages> messages = [
  Messages(
      text: 'Hai',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: true),
  Messages(
      text: 'Hey',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: false),
  Messages(
      text: 'Hello',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: true),
  Messages(
      text: 'Gud mrng',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: false),
  Messages(
      text: 'Gud mrng',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: true),
  Messages(
      text: 'Gud mrng',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: false),
  Messages(
      text: 'Gud mrng',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: true),
  Messages(
      text: 'Hai',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: true),
  Messages(
      text: 'Hey',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: false),
  Messages(
      text: 'Hello',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: true),
  Messages(
      text: 'Gud mrng',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: false),
  Messages(
      text: 'Gud mrng',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: true),
  Messages(
      text: 'Gud mrng',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: false),
  Messages(
      text: 'Gud mrng',
      dateTime: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentbyme: true),
].reversed.toList();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Username'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Column(
            children: [
              Expanded(
                child: GroupedListView<Messages, DateTime>(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(5),
                  //reverse: true,
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  elements: messages,
                  groupBy: (message) => DateTime(
                    message.dateTime.year,
                    message.dateTime.month,
                    message.dateTime.day,
                  ),
                  groupHeaderBuilder: (Messages message) => SizedBox(
                    height: 40,
                    child: Center(
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            DateFormat.yMMMd().format(message.dateTime),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, Messages message) => Container(
                    padding: EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: message.isSentbyme ? 0 : 10,
                        right: message.isSentbyme ? 10 : 0),
                    alignment: message.isSentbyme
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: message.isSentbyme
                          ? const EdgeInsets.only(left: 30)
                          : const EdgeInsets.only(right: 30),
                      padding: const EdgeInsets.only(
                          top: 17, bottom: 17, left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: message.isSentbyme
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                          color: message.isSentbyme
                              ? Theme.of(context).primaryColor
                              : Colors.grey[700]),
                      child: Text(message.text),
                    ),
                  ),
                ),
              ),
              Row(
                children: const [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          label: Text('Write something'),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.send,
                    size: 35,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}