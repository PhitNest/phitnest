part of home_page;

class _ExploreLoadedPage extends StatelessWidget {
  final List<ProfilePicturePublicUserEntity> users;
  final void Function(int pageIndex) onChangePage;
  final int currentPageIndex;
  final int? countdown;

  const _ExploreLoadedPage({
    required this.users,
    required this.onChangePage,
    required this.currentPageIndex,
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
                user: users[currentPageIndex % users.length],
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
