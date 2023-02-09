part of options_page;

extension _Bloc on BuildContext {
  _OptionsBloc get bloc => read();
}

class OptionsPage extends StatelessWidget {
  final T Function<T>(T Function(String accessToken) f) withAuth;
  final ProfilePictureUserEntity initialUser;
  final GymEntity initialGym;

  const OptionsPage({
    Key? key,
    required this.withAuth,
    required this.initialUser,
    required this.initialGym,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _OptionsBloc(
        withAuth: withAuth,
        initialGym: initialGym,
        initialUser: initialUser,
      ),
      child: BlocConsumer<_OptionsBloc, _OptionsState>(
        listener: (context, state) async {
          if (state is _EditProfilePictureState) {
            final photo = await Navigator.of(context).push<XFile>(
              CupertinoPageRoute(
                builder: (context) => ProfilePicturePage(
                  uploadImage: (image) => withAuth(
                    (accessToken) => UseCases.uploadPhotoAuthorized(
                      accessToken: accessToken,
                      photo: image,
                    ),
                  ),
                ),
              ),
            );
            if (photo != null) {}
          } else if (state is _LoadedUserState) {
            context.homeBloc.loadUser(state.response);
          } else if (state is _LoadingErrorState) {
            ScaffoldMessenger.of(context).showMaterialBanner(
              StyledErrorBanner(
                err: state.failure.message,
                context: context,
              ),
            );
          } else if (state is _SignOutErrorState) {
            ScaffoldMessenger.of(context).showMaterialBanner(
              StyledErrorBanner(
                err: state.failure.message,
                context: context,
              ),
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
          } else if (state is _LoadedState) {
            return _InitialPage(
              user: state.response,
              gym: state.response.gym,
              onSignOut: () => context.bloc.add(const _SignOutEvent()),
              onEditProfilePicture: () =>
                  context.bloc.add(const _EditProfilePictureEvent()),
            );
          } else if (state is _InitialState) {
            return _LoadingPage(
              user: state.response,
              gym: state.response.gym,
              onSignOut: () => context.bloc.add(const _SignOutEvent()),
            );
          } else {
            throw Exception('Invalid state: $state');
          }
        },
      ),
    );
  }
}
