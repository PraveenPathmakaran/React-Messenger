import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.username,
      required this.followers,
      required this.following,
      this.bio = 'Available'});
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;

  final List<String> followers;
  final List<String> following;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
        'bio': bio,
      };

  static User fromSnap(DocumentSnapshot<Object?> snap) {
    final Map<String, dynamic> snapshot = snap.data()! as Map<String, dynamic>;

    return User(
      email: snapshot['email'] as String,
      uid: snapshot['uid'] as String,
      photoUrl: snapshot['photoUrl'] as String,
      username: snapshot['username'] as String,
      bio: snapshot['bio'] as String,
      followers: (snapshot['followers'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      following: (snapshot['following'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
    );
  }
}
