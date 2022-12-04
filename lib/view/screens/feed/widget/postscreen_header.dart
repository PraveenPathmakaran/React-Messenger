import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/report_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../services/firestore_methods.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../profile/friend_profile_screen.dart';

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
        children: <Widget>[
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .where('uid', isEqualTo: postSnapShot['uid'])
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatarWidget(
                    networkImagePath:
                        snapshot.data!.docs[0].data()['photoUrl'] as String,
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
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) {
                          return FriendProfileScreen(
                            userId: postSnapShot['uid'] as String,
                          );
                        },
                      ),
                    ),
                    child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('user')
                            .where('uid', isEqualTo: postSnapShot['uid'])
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!.docs[0].data()['username']
                                  as String,
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

  Future<void> postMoreOptionWidget(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          children: <Widget>[
            if (postSnapShot['uid'] == userController.userData.value!.uid)
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text('Delete'),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await postDeleteDialogue(context);
                },
              )
            else
              const SizedBox(),
            if (postSnapShot['uid'] != userController.userData.value!.uid)
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            controller:
                                reportController.reportTextEditingController,
                            decoration: const InputDecoration(
                                hintText: 'Please enter reason'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await reportController.postReport(
                                  postSnapShot['postId'] as String,
                                  postSnapShot['uid'] as String,
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
            else
              const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> postDeleteDialogue(BuildContext context,
      [bool mounted = true]) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conform Delete'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final String res = await FirestoreMethods().deletePost(
                  postSnapShot['postId'] as String,
                  postSnapShot['uid'] as String,
                  postSnapShot['imageId'] as String,
                );
                if (!mounted) {
                  return;
                } //lint remove
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
