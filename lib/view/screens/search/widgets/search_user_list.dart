import 'package:flutter/material.dart';
import '../../../../controller/search_controller.dart';
import '../../../../widgets/widgets.dart';
import '../../profile/profile_screen.dart';

class SearchUserList extends StatelessWidget {
  const SearchUserList({
    Key? key,
    required this.searchController,
  }) : super(key: key);
  final SearchController searchController;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProfileScreen(
              userUid: searchController.postDocumentList.value!.docs[0]
                  .data()['uid']);
        }));
      },
      child: ListTile(
        leading: CircleAvatarWidget(
            networkImagePath: searchController.postDocumentList.value!.docs[0]
                .data()['photoUrl']),
        title: Text(searchController.postDocumentList.value!.docs[0]
            .data()['username']),
      ),
    );
  }
}
