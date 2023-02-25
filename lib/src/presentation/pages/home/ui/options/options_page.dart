part of home_page;

class _OptionsPage extends StatelessWidget {
  const _OptionsPage() : super();

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<_OptionsBloc, _IOptionsState>(
        listener: (context, state) async {
          if (state is _OptionsEditProfilePictureState) {
            XFile? result;
            await context.authMethods.withAuthVoid(
              (accessToken) => Navigator.of(context)
                  .push<XFile>(
                CupertinoPageRoute(
                  builder: (context) => ProfilePicturePage(
                    uploadImage: (image) => UseCases.uploadPhotoAuthorized(
                      accessToken: accessToken,
                      photo: image,
                    ),
                  ),
                ),
              )
                  .then(
                (photo) {
                  if (photo != null) {
                    result = photo;
                    return null;
                  }
                  return null;
                },
              ),
            );
            if (result != null) {
              context.optionsBloc.add(_OptionsSetProfilePictureEvent(result!));
            } else {
              context.optionsBloc.add(const _OptionsLoadedUserEvent());
            }
          }
          if (state is _OptionsSignOutState) {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => LoginPage(),
              ),
              (_) => false,
            );
          }
        },
        builder: (context, state) => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  StyledNetworkProfilePicture(
                    url: Cache.profilePicture.profilePictureUrl!,
                    cacheKey: Cache.profilePicture.profilePictureImageCacheKey,
                  ),
                  Visibility(
                    visible: context.optionsBloc.state is _IOptionsLoadedState,
                    child: Positioned(
                      top: 0,
                      right: 16.w,
                      child: PopupMenuButton(
                        icon: Padding(
                          padding: EdgeInsets.only(
                            top: 16.h,
                          ),
                          child: Icon(
                            Icons.more_horiz_sharp,
                            color: Color(0xFFC11C1C),
                          ),
                        ),
                        iconSize: 48,
                        color: Colors.black,
                        tooltip: 'Edit',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              onTap: () => context.optionsBloc
                                  .add(const _OptionsEditProfilePictureEvent()),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Edit'),
                              ),
                              textStyle: theme.textTheme.labelMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ];
                        },
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
                      Cache.user.user!.fullName,
                      style: theme.textTheme.headlineLarge,
                    ),
                    24.verticalSpace,
                    SizedBox(
                      width: 275.w,
                      child: Text(
                        Cache.user.user!.email,
                        textAlign: TextAlign.left,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    12.verticalSpace,
                    SizedBox(
                      width: 275.w,
                      child: Text(
                        Cache.gym.gym!.toString(),
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    20.verticalSpace,
                    Builder(
                      builder: (context) {
                        if (state is _OptionsSignOutLoadingState ||
                            state is _OptionsSignOutState) {
                          return const CircularProgressIndicator();
                        } else {
                          return StyledUnderlinedTextButton(
                            text: 'SIGN OUT',
                            onPressed: () => context.optionsBloc
                                .add(const _OptionsSignOutEvent()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
