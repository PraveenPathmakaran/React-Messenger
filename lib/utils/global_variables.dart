import 'package:flutter/material.dart';
import 'package:react_messenger/screens/add_post_screen.dart';
import 'package:react_messenger/screens/feed_screen.dart';

const int webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text('search'),
  AddPostScreen(),
  Text('notify'),
  Text('profile'),
];
