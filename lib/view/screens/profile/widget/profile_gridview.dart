import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/widgets.dart';
import 'profile_userfeed.dart';

class ProfileGridviewWidget extends StatelessWidget {
  const ProfileGridviewWidget({
    super.key,
    required this.userUid,
  });

  final String userUid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: userUid)
          .get(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgressIndicator;
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: (snapshot.data!).docs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5),
          itemBuilder: (BuildContext context, int index) {
            final DocumentSnapshot<Object?> snap = (snapshot.data!).docs[index];
            return GestureDetector(
              //this detector for post list view current user
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => ProfileUsersFeed(
                          userData: userUid,
                        )),
              ),
              child: Image(
                image: NetworkImage(
                  (snap.data()! as Map<String, dynamic>)['postUrl'] as String,
                ),
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: Image.asset('assets/images/placeholder.png'),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) =>
                    Image.asset('assets/images/placeholder.png'),
              ),
            );
          },
        );
      },
    );
  }
}
