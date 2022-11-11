import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/const/const.dart';
import 'package:react_messenger/controller/search_controller.dart';
import 'package:react_messenger/view/screens/profile/profile_screen.dart';

// class SearchScreen extends StatelessWidget {
//   SearchScreen({super.key});
//   final SearchController searchController = Get.put(SearchController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: searchController.searchController,
//                   decoration:
//                       const InputDecoration(labelText: "Search for a user"),
//                   onFieldSubmitted: (String _) {
//                     searchController.isShowUsers.value = true;
//                   },
//                 ),
//               ),
//               Icon(Icons.search),
//             ],
//           ),
//         ),
//         body: Obx(() {
//           return searchController.isShowUsers.value
//               ? FutureBuilder(
//                   future: FirebaseFirestore.instance
//                       .collection('user')
//                       .where('username',
//                           isEqualTo: searchController.searchController.text)
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     return ListView.builder(
//                         itemCount: (snapshot.data! as dynamic).docs.length,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: () => Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => ProfileScreen(
//                                   userUid: (snapshot.data! as dynamic)
//                                       .docs[index]['uid'],
//                                 ),
//                               ),
//                             ),
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 backgroundImage: NetworkImage(
//                                     (snapshot.data! as dynamic).docs[index]
//                                         ['photoUrl']),
//                               ),
//                               title: Text(
//                                 (snapshot.data! as dynamic).docs[index]
//                                     ['username'],
//                               ),
//                             ),
//                           );
//                         });
//                   },
//                 )
//               : FutureBuilder(
//                   future: FirebaseFirestore.instance.collection('posts').get(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }

//                     return GridView.builder(
//                       itemCount: (snapshot.data! as dynamic).docs.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2),
//                       itemBuilder: (context, index) {
//                         return Image.network(
//                             (snapshot.data! as dynamic).docs[index]['postUrl']);
//                       },
//                     );
//                   },
//                 );
//         }));
//   }
// }

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  cursorColor: Colors.white,
                  controller: searchController.searchController,
                  decoration: const InputDecoration(
                    labelText: "Search for a user",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
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
          ),
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
                  leading: CircleAvatar(
                    backgroundImage: profilePlaceHolder,
                    foregroundImage: NetworkImage(searchController
                        .postDocumentList.value!.docs[0]
                        .data()['photoUrl']),
                  ),
                  title: Text(searchController.postDocumentList.value!.docs[0]
                      .data()['username']),
                ),
              );
            } else {
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
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
