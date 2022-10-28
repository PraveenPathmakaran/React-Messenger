import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot<Object?> snap) {
    final Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'] as String,
      uid: snapshot['uid'] as String,
      description: snapshot['description'] as String,
      postId: snapshot['postId'] as String,
      datePublished: snapshot['datePublished'] as String,
      postUrl: snapshot['postUrl'] as String,
      profImage: snapshot['profImage'] as String,
      likes: snapshot['likes'],
    );
  }
}
