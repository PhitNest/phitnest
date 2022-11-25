import 'package:flutter/material.dart';

import '../provider.dart';
import 'friends_state.dart';
import 'friends_view.dart';

class FriendProvider extends ScreenProvider<FriendState, FriendsView> {
  @override
  FriendsView build(BuildContext context, FriendState state) => FriendsView(
        searchController: state.searchController,
        friends: state.friend,
      );

  @override
  FriendState buildState() => FriendState();
}
