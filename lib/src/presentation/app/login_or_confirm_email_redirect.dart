part of app;

class _LoginOrRedirectToConfirmEmail extends StatefulWidget {
  /// This widget is used to render the [LoginPage] and push the [ConfirmEmailPage] page ontop of it in the widget stack
  /// if the cached user is not confirmed
  const _LoginOrRedirectToConfirmEmail({
    Key? key,
  }) : super(key: key);

  @override
  _LoginOrRedirectToConfirmEmailState createState() =>
      _LoginOrRedirectToConfirmEmailState();
}

class _LoginOrRedirectToConfirmEmailState
    extends State<_LoginOrRedirectToConfirmEmail> {
  var _disposed = false;

  @override
  void initState() {
    super.initState();
    if (!Cache.user.user!.confirmed) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          if (!_disposed) {
            // The confirm email page will perform a login request after confirming the users
            // email. This is convenient for the user because after confirming their email they
            // will be logged in automatically.
            Navigator.of(context)
              ..push<LoginResponse>(
                CupertinoPageRoute(
                  builder: (context) => ConfirmEmailPage(
                    password: Cache.auth.password,
                    email: Cache.user.user!.email,
                  ),
                ),
              ).then(
                (response) {
                  // If the login request was successful, then we will redirect the user to the home page.
                  if (response != null)
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => HomePage(),
                      ),
                      (_) => false,
                    );
                },
              );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) => const LoginPage();

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
