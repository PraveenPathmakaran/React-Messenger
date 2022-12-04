import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controller/addpost_controller.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? imagePostId;

//add image to firebase
  Future<String> uploadImageStorage(
      String childName, String filePath, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
//is post used for post adding time create seperate post imagePostId
    if (isPost) {
      imagePostId = const Uuid().v1();
      if (imagePostId != null) {
        ref = ref.child(imagePostId!);
      }
    }

    final UploadTask uploadTask = ref.putFile(File(filePath));

    //upload progress

    uploadTask.snapshotEvents.listen((TaskSnapshot event) {
      Get.find<AddPostController>().progress.value =
          ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                  100)
              .roundToDouble();
    });

    final TaskSnapshot snap = await uploadTask;
    final String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> postImageDelete(String userId, String postId) async {
    try {
      await _storage.ref('posts').child(userId).child(postId).delete();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
