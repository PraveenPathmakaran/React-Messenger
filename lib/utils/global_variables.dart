import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:react_messenger/view/screens/addpost/add_post_screen.dart';
import 'package:react_messenger/view/screens/chat/chatlist_screen.dart';
import 'package:react_messenger/view/screens/feed/feed_screen.dart';
import 'package:react_messenger/view/screens/profile/profile_screen.dart';

import '../view/screens/search/search_screen.dart';

const int webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  const ChatListScreen(),
  ProfileScreen(
    userUid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
