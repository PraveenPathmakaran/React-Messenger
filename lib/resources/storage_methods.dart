import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageStorage(
      String childName, Uint8List file, bool isPost) async {
    final Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    final UploadTask uploadTask = ref.putData(file);
    final TaskSnapshot snap = await uploadTask;
    final String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
