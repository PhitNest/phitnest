part of options_page;

abstract class _BasePage extends StatelessWidget {
  final GymEntity gym;
  final ProfilePictureUserEntity user;
  final Widget child;
  final VoidCallback onEditProfilePicture;
  final bool showEdit;

  const _BasePage({
    Key? key,
    required this.gym,
    required this.user,
    required this.child,
    required this.onEditProfilePicture,
    required this.showEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    user.profilePictureUrl,
                    loadingBuilder: (context, child, loadingProgress) =>
                        SizedBox(
                      width: 1.sw,
                      child: Center(
                        child: loadingProgress == null
                            ? child
                            : CircularProgressIndicator(),
                      ),
                    ),
                    errorBuilder: (context, child, loadingProgress) => SizedBox(
                      width: 1.sw,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showEdit,
                    child: Positioned(
                      top: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 32.h,
                          right: 24.w,
                        ),
                        child: PopupMenuButton(
                          icon: Icon(
                            Icons.more_horiz_sharp,
                            color: Color(0xFFC11C1C),
                          ),
                          color: Colors.black,
                          tooltip: 'Edit',
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                onTap: onEditProfilePicture,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Edit'),
                                ),
                                textStyle:
                                    theme.textTheme.labelMedium!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ];
                          },
                        ),
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
