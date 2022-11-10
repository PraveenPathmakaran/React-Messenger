import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/addpost_controller.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//add image to firebase
  Future<String> uploadImageStorage(
      String childName, String filePath, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
//is post used for post adding time create seperate post id
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final UploadTask uploadTask = ref.putFile(File(filePath));

    //upload progress

    uploadTask.snapshotEvents.listen((event) {
      Get.find<AddPostController>().progress.value =
          ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                  100)
              .roundToDouble();
    });
    final TaskSnapshot snap = await uploadTask;
    final String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
