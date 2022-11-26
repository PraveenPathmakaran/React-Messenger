import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:react_messenger/view/screens/profile/widget/profile_userfeed.dart';

import '../../../../widgets/widgets.dart';

class ProfileGridviewWidget extends StatelessWidget {
  const ProfileGridviewWidget({
    Key? key,
    required this.userUid,
  }) : super(key: key);

  final String userUid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: userUid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgressIndicator;
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: (snapshot.data! as dynamic).docs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1.5,
              childAspectRatio: 1),
          itemBuilder: (context, index) {
            DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
            return GestureDetector(
              //this detector for post list view current user
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ProfileUsersFeed(
                          userData: userUid,
                        )),
              ),
              child: Image(
                image: NetworkImage(
                  (snap.data()! as dynamic)['postUrl'],
                ),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: Image.asset("assets/images/placeholder.png"),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/placeholder.png'),
              ),
            );
          },
        );
      },
    );
  }
}
