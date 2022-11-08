import 'package:flutter/material.dart';
import 'package:react_messenger/utils/colors.dart';
import 'package:react_messenger/view/screens/chat/chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Username'),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          OnlineList(),
          SizedBox(
            height: 10,
          ),
          PreviousChat()
        ]),
      ),
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
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                  'https://www.tamiu.edu/newsinfo/images/student-life/campus-scenery.JPG'),
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
  const PreviousChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatScreen())),
                leading: const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      'https://www.tamiu.edu/newsinfo/images/student-life/campus-scenery.JPG'),
                ),
                title: const Text('Username'),
                subtitle: const Text('Subtitle'),
                trailing: const Icon(
                  Icons.brightness_1,
                  color: Colors.green,
                  size: 10,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 2,
              );
            },
            itemCount: 20));
  }
}
