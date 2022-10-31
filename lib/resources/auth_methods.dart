import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../models/user.dart' as model;
import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

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

        final String photoUrl = await StorageMethods()
            .uploadImageStorage('profilePics', file, false);
        //add user to our database

        model.User user = model.User(
            email: email,
            username: username,
            uid: cred.user!.uid,
            fullname: fullname,
            photoUrl: photoUrl,
            followers: [],
            following: []);
        await _firestore.collection('user').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //sign in

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fieild';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
