import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.username,
      required this.followers,
      required this.following,
      this.bio = 'Write something about you'});
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;

  final List<dynamic> followers;
  final List<dynamic> following;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
        'bio': bio,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'] as String,
      uid: snapshot['uid'] as String,
      photoUrl: snapshot['photoUrl'] as String,
      username: snapshot['username'] as String,
      bio: snapshot['bio'] as String,
      followers: snapshot['followers'] as List<dynamic>,
      following: snapshot['following'] as List<dynamic>,
    );
  }
}
