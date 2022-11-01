import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.fullname,
    required this.followers,
    required this.following,
  });
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String fullname;
  final List<dynamic> followers;
  final List<dynamic> following;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'fullname': fullname,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot<Object?> snap) {
    final Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'] as String,
      uid: snapshot['uid'] as String,
      photoUrl: snapshot['photoUrl'] as String,
      username: snapshot['username'] as String,
      fullname: snapshot['fullname'] as String,
      followers: snapshot['followers'] as List<dynamic>,
      following: snapshot['following'] as List<dynamic>,
    );
  }
}
