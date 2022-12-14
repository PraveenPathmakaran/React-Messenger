import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../const/colors.dart';
import '../../../../widgets/widgets.dart';
import '../../feed/widget/post_card.dart';

class ProfileUsersFeed extends StatelessWidget {
  ProfileUsersFeed({super.key, required this.userData});
  final ScrollController scrollController = ScrollController();
  final String userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: '',
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: userData)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgressIndicator;
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView.separated(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) => PostCard(
                    postSnapShot: snapshot.data!.docs[index].data(),
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      thickness: 2,
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
