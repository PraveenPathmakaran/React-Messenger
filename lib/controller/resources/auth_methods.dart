import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/user.dart' as model;
import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String rePassword,
    required String username,
    required String password,
    required String file,
  }) async {
    String res = 'Some error';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          rePassword.isNotEmpty ||
          username.isNotEmpty ||
          file.isNotEmpty) {
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

  Future<void> googleLogin() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    final googleAuth = await googleUser.authentication;

    try {
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.credential == null || _auth.currentUser == null) {
        return;
      }

      model.User user = model.User(
          email: _auth.currentUser!.email!,
          username: _auth.currentUser!.displayName!,
          uid: userCredential.user!.uid,
          photoUrl: _auth.currentUser!.photoURL!,
          followers: [],
          following: []);
      await _firestore.collection('user').doc(userCredential.user!.uid).set(
            user.toJson(),
          );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
