part of options_page;

abstract class _BasePage extends StatelessWidget {
  final GymEntity gym;
  final ProfilePictureUserEntity user;
  final Widget child;
  final VoidCallback onEditProfilePicture;

  const _BasePage({
    Key? key,
    required this.gym,
    required this.user,
    required this.child,
    required this.onEditProfilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          child: Column(
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
                      child: IconButton(
                        icon: Icon(Icons.more_horiz_sharp),
                        onPressed: onEditProfilePicture,
                        color: Color(0xFFC11C1C),
                      ),
                    ),
                  ),
                ],
              ),
              40.verticalSpace,
              SizedBox(
                width: 291.w,
                child: Column(
                  children: [
                    Text(
                      user.fullName,
                      style: theme.textTheme.headlineLarge,
                    ),
                    // 32.verticalSpace,
                    Text(
                      user.email,
                      style: theme.textTheme.labelMedium,
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    12.verticalSpace,
                    Text(
                      'Address',
                      style: theme.textTheme.headlineLarge,
                    ),
                    // 32.verticalSpace,
                    Text(
                      gym.toString(),
                      style: theme.textTheme.labelMedium,
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    45.verticalSpace,
                    child,
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
