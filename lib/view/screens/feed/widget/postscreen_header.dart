import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/report_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../services/firestore_methods.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../profile/profile_screen.dart';

class PostHeaderSection extends StatelessWidget {
  PostHeaderSection({super.key, required this.postSnapShot});
  final Map<String, dynamic> postSnapShot;
  final UserController userController = Get.put(UserController());
  final ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .where('uid', isEqualTo: postSnapShot['uid'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatarWidget(
                    networkImagePath: snapshot.data!.docs[0].data()['photoUrl'],
                    radius: 16,
                  );
                } else {
                  return const SizedBox();
                }
              }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          bool value = userController.userData.value!.uid ==
                                  postSnapShot['uid']
                              ? true
                              : false;
                          return ProfileScreen(
                            userUid: postSnapShot['uid'],
                            currentUser: value,
                          );
                        },
                      ),
                    ),
                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('user')
                            .where('uid', isEqualTo: postSnapShot['uid'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!.docs[0].data()['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await postMoreOptionWidget(context);
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  postMoreOptionWidget(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          children: [
            postSnapShot['uid'] == userController.userData.value!.uid
                ? InkWell(
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Text('Delete'),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await postDeleteDialogue(context);
                    },
                  )
                : const SizedBox(),
            postSnapShot['uid'] != userController.userData.value!.uid
                ? InkWell(
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Text('Report'),
                    ),
                    onTap: () {
                      Get.back();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter the report reason'),
                              content: TextField(
                                controller: reportController
                                    .reportTextEditingController,
                                decoration: const InputDecoration(
                                    hintText: 'Please enter reason'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await reportController.postReport(
                                      postSnapShot['postId'],
                                      postSnapShot['uid'],
                                      userController.userData.value!.uid,
                                      context,
                                    );

                                    if (reportController.result == 'Success') {
                                      Get.back();
                                    }
                                  },
                                  child: Obx(() {
                                    return reportController.isLoading.value
                                        ? circularProgressIndicator
                                        : const Text('Confirm');
                                  }),
                                ),
                              ],
                            );
                          });
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  postDeleteDialogue(BuildContext context, [bool mounted = true]) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Conform Delete'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final res = await FirestoreMethods().deletePost(
                  postSnapShot['postId'],
                  postSnapShot['uid'],
                  postSnapShot['imageId'],
                );
                if (!mounted) return; //lint remove
                if (res == 'success') {
                  showSnackBar('Successfully deleted', context);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
