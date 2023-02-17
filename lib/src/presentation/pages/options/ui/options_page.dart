part of options_page;

extension _Bloc on BuildContext {
  _OptionsBloc get bloc => read();
}

class OptionsPage extends StatelessWidget {
  final ProfilePictureUserEntity initialUser;
  final GymEntity initialGym;
  final ValueChanged<GetUserResponse> onLoadedUser;

  const OptionsPage({
    Key? key,
    required this.initialUser,
    required this.initialGym,
    required this.onLoadedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _OptionsBloc(
        withAuth: context.withAuth,
        withAuthVoid: context.withAuthVoid,
        initialGym: initialGym,
        initialUser: initialUser,
      ),
      child: BlocConsumer<_OptionsBloc, _IOptionsState>(
        listener: (context, state) async {
          if (state is _EditProfilePictureState) {
            XFile? result;
            await context.withAuthVoid(
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
                  return Failure("", "");
                },
              ),
            );
            if (result != null) {
              context.bloc.add(_SetProfilePictureEvent(result!));
            } else {
              context.bloc.add(_LoadedUserEvent(response: state.response));
            }
          } else if (state is _LoadedUserState) {
            await CachedNetworkImage.evictFromCache(
                Cache.profilePictureImageCache);
            onLoadedUser(state.response);
          } else if (state is _LoadingErrorState) {
            StyledErrorBanner.show(
              context,
              state.failure,
              state.dismiss,
            );
          } else if (state is _SignOutErrorState) {
            StyledErrorBanner.show(
              context,
              state.failure,
              state.dismiss,
            );
          } else if (state is _SignOutSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => LoginPage(),
              ),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is _SignOutLoadingState) {
            return _SignOutLoadingPage(
              user: state.response,
              gym: state.response.gym,
            );
          } else if (state is _ILoadedState) {
            return _InitialPage(
              user: state.response,
              gym: state.response.gym,
              onSignOut: () => context.bloc.add(const _SignOutEvent()),
              onEditProfilePicture: () =>
                  context.bloc.add(const _EditProfilePictureEvent()),
            );
          } else {
            return _LoadingPage(
              user: state.response,
              gym: state.response.gym,
              onSignOut: () => context.bloc.add(const _SignOutEvent()),
            );
          }
        },
      ),
    );
  }
}
