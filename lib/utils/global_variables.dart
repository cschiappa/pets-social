import 'package:flutter/cupertino.dart';
import 'package:pets_social/screens/add_post_screen.dart';
import 'package:pets_social/screens/notifications_screen.dart';

import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  const ProfileScreen(),
];
