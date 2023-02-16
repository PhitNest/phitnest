part of app;

class _LoginOrRedirectToConfirmEmail extends StatefulWidget {
  /// Push the [ConfirmEmailPage] onto the navigation stack if true. Otherwise, render the [LoginPage].
  ///
  /// If this is true, then [email] and [password] must not be null.
  final bool shouldRedirect;

  /// Used on the [ConfirmEmailPage] to perform a login request after confirming the users email.
  final String? password;

  /// Used on the [ConfirmEmailPage] to perform a login request after confirming the users email.
  final String? email;

  /// This widget is used to render the [LoginPage] and push the [ConfirmEmailPage] page ontop of it in the widget stack
  /// if the [shouldRedirect] condition is met.
  ///
  /// If [shouldRedirect] is true, then the [email] and [password] must not be null. This is because they are both required
  /// for the [ConfirmEmailPage] to function properly.
  const _LoginOrRedirectToConfirmEmail({
    Key? key,
    required this.shouldRedirect,
    required this.email,
    required this.password,
  })  : assert((shouldRedirect && email != null && password != null) ||
            !shouldRedirect),
        super(key: key);

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
    if (widget.shouldRedirect) {
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
                    password: widget.password,
                    email: widget.email!,
                  ),
                ),
              ).then(
                (response) {
                  // If the login request was successful, then we will redirect the user to the home page.
                  if (response != null)
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => HomePage(
                          initialData: response,
                          initialPassword: widget.password!,
                        ),
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
