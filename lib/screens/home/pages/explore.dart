part of '../home.dart';

class ExploreScreen extends StatelessWidget {
  final List<UserWithProfilePicture> users;
  final PageController pageController;
  final int? countdown;

  const ExploreScreen({
    super.key,
    required this.users,
    required this.pageController,
    required this.countdown,
  }) : super();

  @override
  Widget build(BuildContext context) => users.isEmpty
      ? const EmptyPage()
      : PageView.builder(
          controller: pageController,
          itemBuilder: (context, page) => UserPage(
            user: users[page % users.length],
            countdown: countdown != null
                ? page == pageController.page?.round()
                    ? countdown
                    : null
                : null,
          ),
        );
}
