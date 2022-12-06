import 'package:flutter/material.dart';

import '../provider.dart';
import 'friends_state.dart';
import 'friends_view.dart';
import 'widgets/widgets.dart';

class FriendsProvider extends ScreenProvider<FriendsState, FriendsView> {
  const FriendsProvider() : super();

  @override
  FriendsView build(BuildContext context, FriendsState state) => FriendsView(
        searchController: state.searchController,
        onEditSearch: state.onEditSearch,
        friends: state.friends
            .asMap()
            .entries
            .where(
              (entry) => entry.value.fullName.toLowerCase().contains(
                    state.searchController.text.toLowerCase(),
                  ),
            )
            .map(
              (entry) => FriendCard(
                name: entry.value.fullName,
                onRemove: () => state.removeFriend(entry.key),
              ),
            )
            .toList(),
        requests: state.requests
            .asMap()
            .entries
            .where(
              (entry) => entry.value.fullName.toLowerCase().contains(
                    state.searchController.text.toLowerCase(),
                  ),
            )
            .map(
              (entry) => RequestCard(
                user: entry.value,
                onAdd: () => state.removeRequest(entry.key),
                onIgnore: () => state.removeRequest(entry.key),
              ),
            )
            .toList(),
      );

  @override
  FriendsState buildState() => FriendsState();
}
