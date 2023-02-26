part of home_page;

class _ExploreLoadedPage extends StatelessWidget {
  final List<ProfilePicturePublicUserEntity> users;
  final PageController pageController;
  final int? countdown;

  const _ExploreLoadedPage({
    required this.users,
    required this.pageController,
    this.countdown,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Flexible(
            child: PageView.builder(
              key: PageStorageKey("explore_page_view"),
              controller: pageController,
              itemBuilder: (context, index) => _ExploreCard(
                countdown: (index % users.length) ==
                        (pageController.page?.round() ?? 0 % users.length)
                    ? countdown
                    : null,
                user: users[index % users.length],
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
