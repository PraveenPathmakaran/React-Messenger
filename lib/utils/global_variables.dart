import 'package:flutter/material.dart';
import '../view/screens/addpost/add_post_screen.dart';
import '../view/screens/chat/chatlist_screen.dart';
import '../view/screens/feed/feed_screen.dart';
import '../view/screens/profile/profile_screen.dart';

import '../view/screens/search/search_screen.dart';

const int webScreenSize = 600;

List<Widget> homeScreenItems = <Widget>[
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  ChatListScreen(),
  ProfileScreen(),
];
