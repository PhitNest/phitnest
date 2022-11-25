import 'package:flutter/material.dart';

import '../state.dart';
import 'model/friend_model.dart';

class FriendState extends ScreenState {
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
}
