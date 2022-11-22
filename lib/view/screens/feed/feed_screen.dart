import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/view/screens/feed/widget/post_card.dart';
import 'package:react_messenger/widgets/widgets.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({super.key});
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'React Messenger',
        centerTitle: false,
        backgroundColor: lightDarColor,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgressIndicator;
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    postSnapShot: snapshot.data!.docs[index].data(),
                  ),
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: mobileBackgroundColor,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
