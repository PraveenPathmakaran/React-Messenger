import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/posts.dart';
import '../models/report.dart';
import 'storage_methods.dart';

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
    String res = 'Some error occur';
    try {
      final String photoUrl = await storageMethods.uploadImageStorage(
        'posts',
        filePath,
        true,
      );
      if (storageMethods.imagePostId != null) {
        imageId = storageMethods.imagePostId!;
      }

      final String postId = const Uuid().v1();
      final Post post = Post(
        description: description,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        likes: <String>[],
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
  Future<void> likePost(String postId, String uid, List<String> likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update(<String, dynamic>{
          'likes': FieldValue.arrayRemove(<String>[uid]),
        });
      } else {
        _firestore.collection('posts').doc(postId).update(<String, dynamic>{
          'likes': FieldValue.arrayUnion(<String>[uid]),
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
        final String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(<String, dynamic>{
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
      await _firestore.collection('report').doc(imageId).delete();
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
      final DocumentSnapshot<Object?> snap =
          await _firestore.collection('user').doc(uid).get();

      final List<String> following =
          ((snap.data()! as Map<String, dynamic>)['following'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList();

      if (following.contains(followId)) {
        await _firestore
            .collection('user')
            .doc(followId)
            .update(<String, dynamic>{
          'followers': FieldValue.arrayRemove(<String>[uid])
        });
        await _firestore.collection('user').doc(uid).update(<String, dynamic>{
          'following': FieldValue.arrayRemove(<String>[followId])
        });
      } else {
        await _firestore
            .collection('user')
            .doc(followId)
            .update(<String, dynamic>{
          'followers': FieldValue.arrayUnion(<String>[uid])
        });
        await _firestore.collection('user').doc(uid).update(<String, dynamic>{
          'following': FieldValue.arrayUnion(<String>[followId])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  Future<String> reportPost(Map<String, dynamic> postData) async {
    List<Report> listOfReportObject =
        <Report>[]; //for fetchig firebase report database
    List<Map<String, dynamic>> listOfReportMap =
        <Map<String, dynamic>>[]; //convert report object to json
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection('report')
        .doc(postData['postId'] as String)
        .get();
//if firebase has some value then this if condition will work
    if (doc.data() != null) {
      final List<Map<String, dynamic>> listOfReports =
          List<Map<String, dynamic>>.from(
                  doc.data()!['report'] as List<dynamic>)
              .map((dynamic e) => e as Map<String, dynamic>)
              .toList();

      //generate report model
      listOfReportObject = List<Report>.from(
        listOfReports.map(
          (Map<String, dynamic> e) => Report.fromSnap(e),
        ),
      );
    }
    //new report add to database
    listOfReportObject.add(Report.fromSnap(postData));
//converting json format for uploading
    listOfReportMap = List<Map<String, dynamic>>.from(
        listOfReportObject.map((Report e) => e.toJson()));

    String res = 'Some error occur';
    try {
      _firestore.collection('report').doc(postData['postId'] as String).set(
        <String, dynamic>{'report': listOfReportMap},
      );
      res = 'Success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
