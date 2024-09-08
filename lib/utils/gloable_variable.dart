import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:linkup/screens/add_post_screen.dart';
import 'package:linkup/screens/feed_screen.dart';
import 'package:linkup/screens/profile_screen.dart';
import 'package:linkup/screens/search_screen.dart';

const webScreenSize=600;

List<Widget> homeScreenItems=[
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notification'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
