import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';

class SearchGridview extends StatelessWidget {
  const SearchGridview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('posts').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgressIndicator;
        }
        return Column(
          children: [
            kHeight25,
            GridView.builder(
              shrinkWrap: true,
              itemCount: (snapshot.data! as dynamic).docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                return Image.network(
                  (snapshot.data! as dynamic).docs[index]['postUrl'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl'],
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Image.asset('assets/images/placeholder.png');
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
