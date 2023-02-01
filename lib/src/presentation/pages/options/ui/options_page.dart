part of options_page;

class OptionsPage extends StatelessWidget {
  final ProfilePictureUserEntity user;
  final GymEntity gym;

  const OptionsPage({
    Key? key,
    required this.user,
    required this.gym,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _OptionsBloc(),
      child: BlocConsumer<_OptionsBloc, _OptionsState>(
        listener: (context, state) => {
          if (state is _ErrorState)
            {
              ScaffoldMessenger.of(context).showMaterialBanner(
                StyledErrorBanner(
                  err: state.failure.message,
                  context: context,
                ),
              ),
            }
          else if (state is _SuccessState)
            {
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => Scaffold()),
                  (_) => false)
            }
        },
        builder: (context, state) {
          if (state is _LoadingState) {
            return _LoadingPage(
              address:
                  gym.name + ', ' + gym.address.city + ', ' + gym.address.state,
              email: user.email,
              name: user.firstName + ' ' + user.lastName,
              profilePicUri: user.profilePictureUrl,
            );
          } else {
            final _initialProps = state as _InitialState;
            return _InitialPage(
              name: user.firstName + ' ' + user.lastName,
              email: user.email,
              address:
                  gym.name + ', ' + gym.address.city + ', ' + gym.address.state,
              profilePicUri: user.profilePictureUrl,
              onSignOut: () =>
                  context.read<_OptionsBloc>().add(_SignOutEvent()),
            );
          }
        },
      ),
    );
  }
}
