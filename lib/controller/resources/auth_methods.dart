import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:react_messenger/controller/login_controller.dart';
import '../../models/user.dart' as model;
import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final LoginController loginController = Get.put(LoginController());

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

  Future<String> googleLogin() async {
    String res = 'Some error';
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return 'User is null';
    final googleAuth = await googleUser.authentication;

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
      loginController.gIsLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
