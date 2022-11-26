import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
    this.status = true,
    required this.imageId,
  });
  final String description;
  final String uid;
  final String postId;
  final datePublished;
  final String postUrl;
  final likes;
  final bool status;
  final String imageId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'uid': uid,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'likes': likes,
        'status': status,
        'imageId': imageId,
      };

  static Post fromSnap(DocumentSnapshot<Object?> snap) {
    final Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        uid: snapshot['uid'] as String,
        description: snapshot['description'] as String,
        postId: snapshot['postId'] as String,
        datePublished: snapshot['datePublished'] as String,
        postUrl: snapshot['postUrl'] as String,
        likes: snapshot['likes'],
        status: snapshot['status'],
        imageId: snapshot['imageId']);
  }
}
