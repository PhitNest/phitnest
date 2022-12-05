import 'package:flutter/material.dart';

import '../provider.dart';
import 'friends_state.dart';
import 'friends_view.dart';

class FriendsProvider extends ScreenProvider<FriendsState, FriendsView> {
  const FriendsProvider() : super();

  @override
  FriendsView build(BuildContext context, FriendsState state) => FriendsView(
        searchController: state.searchController,
        friends: state.friends,
        requests: state.requests,
        addFriend: () {},
        ignoreRequest: () {},
        removeFriend: () {},
      );

  @override
  FriendsState buildState() => FriendsState();
}
