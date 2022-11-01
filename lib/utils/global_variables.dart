import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:react_messenger/view/screens/add_post_screen.dart';
import 'package:react_messenger/view/screens/feed_screen.dart';
import 'package:react_messenger/view/screens/profile_screen.dart';

import '../view/screens/search_screen.dart';

const int webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notify'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
