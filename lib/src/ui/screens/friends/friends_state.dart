import 'package:flutter/material.dart';

import '../state.dart';
import 'models/friend_model.dart';

class FriendsState extends ScreenState {
  final TextEditingController searchController = TextEditingController();

  List<FriendModel> friend = [
    FriendModel(
      name: 'Json M.',
      isFriend: true,
    ),
    FriendModel(
      name: 'James B.',
      isFriend: true,
    ),
    FriendModel(
      name: 'Zane M.',
      isFriend: true,
    ),
    FriendModel(
      name: 'Rahul P.',
      isFriend: true,
    ),
    FriendModel(
      name: 'Erin-Michelle J.',
      isFriend: false,
    ),
    FriendModel(
      name: 'Umaar E.',
      isFriend: false,
    ),
    FriendModel(
      name: 'Turner W.',
      isFriend: false,
    ),
  ];

  List<FriendModel> get friends =>
      friend.where((f) => f.isFriend == true).toList();

  List<FriendModel> get requests =>
      friend.where((f) => f.isFriend == false).toList();
}
