part of friends_page;

class FriendsPage extends StatelessWidget {
  final Stream<FriendRequestEntity> friendRequests;
  final Stream<FriendshipEntity> friendships;

  const FriendsPage({
    Key? key,
    required this.friendRequests,
    required this.friendships,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _LoadedPage();
  }
}
