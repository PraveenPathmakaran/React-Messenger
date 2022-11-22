import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/search_controller.dart';
import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/view/screens/profile/profile_screen.dart';

import '../../../widgets/widgets.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: lightDarColor,
          title: SearchAppBarTitle(searchController: searchController),
        ),
        body: Obx(
          () {
            if (searchController.postDocumentList.value != null) {
              if (searchController.postDocumentList.value!.size == 0) {
                return const Center(
                  child: Text('User not found'),
                );
              }
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ProfileScreen(
                        userUid: searchController
                            .postDocumentList.value!.docs[0]
                            .data()['uid']);
                  }));
                },
                child: ListTile(
                  leading: CircleAvatarWidget(
                      networkImagePath: searchController
                          .postDocumentList.value!.docs[0]
                          .data()['photoUrl']),
                  title: Text(searchController.postDocumentList.value!.docs[0]
                      .data()['username']),
                ),
              );
            } else {
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return Image.network(
                            (snapshot.data! as dynamic).docs[index]['postUrl'],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return Image.network(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['postUrl'],
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Image.asset(
                                    'assets/images/placeholder.png');
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
          },
        ),
      ),
    );
  }
}

class SearchAppBarTitle extends StatelessWidget {
  const SearchAppBarTitle({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  final SearchController searchController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextFormField(
            cursorColor: Colors.white,
            controller: searchController.searchController,
            decoration: const InputDecoration(
              labelText: "Search for a user",
              labelStyle: TextStyle(color: Colors.white),
            ),
            onFieldSubmitted: (String value) {
              if (value.isEmpty) {
                searchController.postDocumentList.value = null;
                return;
              }
              searchController.initSearchingPost(value);
            },
            onChanged: (String value) {
              if (value.isEmpty) {
                searchController.postDocumentList.value = null;
                return;
              }
              searchController.name = value;
            },
          ),
        ),
        IconButton(
          onPressed: () {
            searchController.initSearchingPost(searchController.name);
          },
          icon: const Icon(Icons.search),
        )
      ],
    );
  }
}
