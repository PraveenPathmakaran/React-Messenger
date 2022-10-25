import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String fullname,
    required String username,
    required String password,
    required Uint8List file,
  }) async {
    String res = 'Some error';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          fullname.isNotEmpty ||
          username.isNotEmpty) {
        final UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageStorage('profilePics', file, false);
        //add user to our database
        await _firestore
            .collection('user')
            .doc(cred.user!.uid)
            .set(<String, dynamic>{
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'fullname': fullname,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
