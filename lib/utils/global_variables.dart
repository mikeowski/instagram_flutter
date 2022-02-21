import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  Center(child: Text('feed')),
  Center(child: Text('search')),
  addPostScreen(),
  Center(child: Text('favorites')),
  Center(child: Text('profile')),
];
