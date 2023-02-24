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
              context.optionsBloc
                  .add(_OptionsLoadedUserEvent(response: state.response));
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
        builder: (context, state) {
          if (state is _OptionsSignOutLoadingState ||
              state is _OptionsSignOutState) {
            return _OptionsSignOutLoadingPage(
              user: state.response,
              gym: state.response.gym,
            );
          } else if (state is _IOptionsLoadedState) {
            return _OptionsInitialPage(
              user: state.response,
              gym: state.response.gym,
              onSignOut: () =>
                  context.optionsBloc.add(const _OptionsSignOutEvent()),
              onEditProfilePicture: () => context.optionsBloc
                  .add(const _OptionsEditProfilePictureEvent()),
            );
          } else {
            return _OptionsLoadingPage(
              user: state.response,
              gym: state.response.gym,
              onSignOut: () =>
                  context.optionsBloc.add(const _OptionsSignOutEvent()),
            );
          }
        },
      );
}
