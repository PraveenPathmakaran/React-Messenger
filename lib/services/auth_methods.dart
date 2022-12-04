import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../controller/login_controller.dart';
import '../models/user.dart' as model;
import '../utils/utils.dart';
import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final LoginController loginController = Get.put(LoginController());

  final Reference storageRef = FirebaseStorage.instance.ref();
  bool mounted = true;

  Future<model.User> getUserDetails() async {
    final User currentUser = _auth.currentUser!;
    await _auth.currentUser!.reload();
    final DocumentSnapshot<Object?> snap =
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

        final model.User user = model.User(
            email: email,
            username: username,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            followers: <String>[],
            following: <String>[]);
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
        await _auth.currentUser!.reload();
      } else {
        res = 'Please enter all the fieild';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//google signup and login
  Future<String> googleSingUp() async {
    String res = 'Some error';
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return 'User is null';
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    try {
      loginController.gIsLoading.value = true;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.credential == null || _auth.currentUser == null) {
        return 'User credential null';
      }
      res = 'Success';

      final model.User user = model.User(
        email: _auth.currentUser!.email!,
        username: _auth.currentUser!.displayName!,
        uid: userCredential.user!.uid,
        photoUrl: _auth.currentUser!.photoURL!,
        followers: <String>[],
        following: <String>[],
      );
      await _firestore.collection('user').doc(userCredential.user!.uid).set(
            user.toJson(),
          );
      loginController.gIsLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<String> googleLogin(BuildContext context) async {
    String res = 'Some error';
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return 'User is null';
    }
    //fetch method used for google auth bug if user click google authentification that time new account created.
    final List<String> listOfUser =
        await _auth.fetchSignInMethodsForEmail(googleUser.email);
    if (listOfUser.contains('google.com')) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      try {
        loginController.gIsLoading.value = true;
        final OAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.credential == null || _auth.currentUser == null) {
          return 'User credential null';
        }
        res = 'Success';
        await _auth.currentUser!.reload();

        loginController.gIsLoading.value = false;
      } catch (e) {
        log(e.toString());
      }
    } else {
      if (!mounted) {
        return '';
      } //for linter remove build context async gap
      showSnackBar('Account not found Please Sign up', context);
    }

    return res;
  }

//user profile pic,username and bio update
  Future<String> updateUser(
      {required String username,
      required String? file,
      required String bio,
      required String userId}) async {
    String res = 'Some error';
    try {
      if (username.isNotEmpty || bio.isNotEmpty) {
        if (file != null) {
          final Reference imageRef =
              storageRef.child('profilePics').child(userId);
          final UploadTask uploadTask = imageRef.putFile(File(file));
          final TaskSnapshot snap = await uploadTask;
          final String downloadUrl = await snap.ref.getDownloadURL();
          await _firestore
              .collection('user')
              .doc(userId)
              .update(<String, dynamic>{
            'bio': bio,
            'username': username,
            'photoUrl': downloadUrl
          });

          return res = 'success';
        }

        await _firestore
            .collection('user')
            .doc(userId)
            .update(<String, dynamic>{
          'bio': bio,
          'username': username,
        });

        res = 'success';
        Get.back();
      }
    } catch (err) {
      res = err.toString();
      Get.snackbar('title', err.toString());
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
