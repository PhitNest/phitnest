part of options_page;

extension _Bloc on BuildContext {
  _OptionsBloc get bloc => read();
}

class OptionsPage extends StatelessWidget {
  final T Function<T>(T Function(String accessToken) f) withAuth;
  final ProfilePictureUserEntity user;
  final GymEntity gym;

  const OptionsPage({
    Key? key,
    required this.withAuth,
    required this.user,
    required this.gym,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _OptionsBloc(withAuth: withAuth),
      child: BlocConsumer<_OptionsBloc, _OptionsState>(
        listener: (context, state) {
          if (state is _ErrorState) {
            ScaffoldMessenger.of(context).showMaterialBanner(
              StyledErrorBanner(
                err: state.failure.message,
                context: context,
              ),
            );
          } else if (state is _SuccessState) {
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
            return _LoadingPage(
              user: user,
              gym: gym,
              onEditProfilePicture: () =>
                  ImagePicker().pickImage(source: ImageSource.gallery).then(
                (img) {
                  if (img != null) {
                    context.bloc
                        .add(_EditProfilePictureEvent(newProfilePicture: img));
                  }
                },
              ),
            );
          } else {
            return _InitialPage(
              user: user,
              gym: gym,
              onSignOut: () => context.bloc.add(const _SignOutEvent()),
              onEditProfilePicture: () {},
            );
          }
        },
      ),
    );
  }
}
