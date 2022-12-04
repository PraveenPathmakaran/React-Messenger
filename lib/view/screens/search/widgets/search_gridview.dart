import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/widgets.dart';
import '../../profile/friend_profile_screen.dart';

class SearchGridview extends StatelessWidget {
  const SearchGridview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('posts').get(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return circularProgressIndicator;
        }
        return Column(
          children: <Widget>[
            kHeight25,
            GridView.builder(
              shrinkWrap: true,
              itemCount: (snapshot.data!).docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Get.to(() => FriendProfileScreen(
                      userId: (snapshot.data!).docs[index]['uid'] as String)),
                  child: Image.network(
                    (snapshot.data!).docs[index]['postUrl'] as String,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return Image.network(
                          (snapshot.data!).docs[index]['postUrl'] as String,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.asset('assets/images/placeholder.png');
                      }
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
