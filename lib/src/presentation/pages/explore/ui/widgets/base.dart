part of explore_page;

class _LoadedPage extends StatelessWidget {
  final List<ProfilePicturePublicUserEntity> users;
  final void Function(int pageIndex) onChangePage;
  final int? countdown;

  const _LoadedPage({
    required this.users,
    required this.onChangePage,
    this.countdown,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Flexible(
            child: PageView.builder(
              onPageChanged: onChangePage,
              itemBuilder: (context, index) => _ExploreCard(
                countdown: countdown,
                profilePictureUrl:
                    users[index % users.length].profilePictureUrl,
                fullName: users[index % users.length].fullName,
              ),
            ),
          ),
          Text(
            'Press and hold logo to send friend request',
            style: theme.textTheme.bodySmall,
          ),
          30.verticalSpace,
        ],
      );
}
