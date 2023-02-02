part of options_page;

abstract class _BasePage extends StatelessWidget {
  final GymEntity gym;
  final ProfilePictureUserEntity user;
  final Widget child;

  const _BasePage({
    Key? key,
    required this.gym,
    required this.user,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Image.network(user.profilePictureUrl),
                Padding(
                  padding: EdgeInsets.only(
                    top: 32.h,
                    right: 24.w,
                  ),
                  child: Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.more_horiz_sharp,
                      color: Color(0xFFC11C1C),
                    ),
                  ),
                ),
              ],
            ),
            40.verticalSpace,
            Text(
              user.fullName,
              style: theme.textTheme.headlineLarge,
            ),
            32.verticalSpace,
            Text(
              user.email,
              style: theme.textTheme.labelLarge,
            ),
            Divider(),
            24.verticalSpace,
            Text(
              'Address',
              style: theme.textTheme.headlineLarge,
            ),
            32.verticalSpace,
            Text(
              gym.toString(),
              style: theme.textTheme.labelLarge,
            ),
            Divider(),
            45.verticalSpace,
            child,
          ],
        ),
      );
}
