part of 'home.dart';

typedef GetGymBloc = AuthLoaderBloc<void, HttpResponse<void>>;
typedef GetGymConsumer = AuthLoaderConsumer<void, HttpResponse<void>>;

extension GetGymBlocGetter on BuildContext {
  GetGymBloc get getGymBloc => authLoader();
}

void _returnToLogin(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const LoginPage(),
      ),
      (_) => false,
    );

void _handleLogoutStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<void>> logoutState,
) {
  switch (logoutState) {
    case LoaderLoadedState():
      _returnToLogin(context);
    default:
  }
}

void _handleGetGymStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<void>>> getGymState,
) {
  switch (getGymState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthLost():
          _returnToLogin(context);
        default:
      }
    default:
  }
}
