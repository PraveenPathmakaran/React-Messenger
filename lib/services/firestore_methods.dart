import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:react_messenger/models/posts.dart';
import 'package:react_messenger/models/report.dart';
import 'package:react_messenger/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods storageMethods = StorageMethods();
  String imageId = '';
//upload post
  Future<String> uploadPost(
    String description,
    String filePath,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "Some error occur";
    try {
      String photoUrl = await storageMethods.uploadImageStorage(
        'posts',
        filePath,
        true,
      );
      if (storageMethods.imagePostId != null) {
        imageId = storageMethods.imagePostId!;
      }

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        likes: [],
        imageId: imageId,
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'Success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

//comment post
  Future<void> postComments(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        if (kDebugMode) {
          print('Text is empty');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  //delete comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      log(e.toString());
    }
  }

  //delete post

  Future<String> deletePost(
      String postImageId, String userId, String imageId) async {
    String res = 'Some error';
    try {
      await _firestore.collection('posts').doc(postImageId).delete();
      StorageMethods().postImageDelete(userId, imageId);
      return res = 'success';
    } catch (e) {
      e.toString();
    }
    return res;
  }

//follow user
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('user').doc(uid).get();

      List following = (snap.data() as Map<String, dynamic>)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  Future<String> reportPost(Map<String, dynamic> postData) async {
    List<Report> listOfReportObject = []; //for fetchig firebase report database
    List<Map<String, dynamic>> listOfReportMap =
        []; //convert report object to json
    final doc =
        await _firestore.collection('report').doc(postData['postId']).get();
//if firebase has some value then this if condition will work
    if (doc.data() != null) {
      final listOfReports = doc.data()!['report'];
      listOfReportObject =
          List<Report>.from(listOfReports.map((e) => Report.fromSnap(e)));
    }
    //new report add to database
    listOfReportObject.add(Report.fromSnap(postData));
//converting json format for uploading
    listOfReportMap = List<Map<String, dynamic>>.from(
        listOfReportObject.map((e) => e.toJson()));

    String res = "Some error occur";
    try {
      _firestore
          .collection('report')
          .doc(postData['postId'])
          .set({'report': listOfReportMap});
      res = 'Success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
