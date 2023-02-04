part of options_page;

class _OptionsBloc extends Bloc<_OptionsEvent, _OptionsState> {
  final T Function<T>(T Function(String accessToken) f) withAuth;

  _OptionsBloc({
    required this.withAuth,
  }) : super(_InitialState()) {
    on<_SignOutEvent>(onSignOut);
    on<_ErrorEvent>(onErrorCaught);
    on<_SuccessEvent>(onSignOutSuccess);
    on<_EditProfilePictureEvent>(onEditProfilePicture);
  }
}
