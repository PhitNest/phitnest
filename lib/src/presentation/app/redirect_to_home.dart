part of app;

class _RedirectHome extends StatefulWidget {
  final String accessToken;
  final String refreshToken;
  final GymEntity gym;
  final UserEntity user;
  final String profilePictureUrl;
  final String password;

  /// This is used to redirect to the home page from the root of [App].
  const _RedirectHome({
    Key? key,
    required this.accessToken,
    required this.refreshToken,
    required this.gym,
    required this.user,
    required this.profilePictureUrl,
    required this.password,
  }) : super(key: key);

  @override
  _RedirectHomeState createState() => _RedirectHomeState();
}

class _RedirectHomeState extends State<_RedirectHome> {
  var _disposed = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (!_disposed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePage(
                  initialData: LoginResponse(
                    accessToken: widget.accessToken,
                    refreshToken: widget.refreshToken,
                    user: ProfilePictureUserEntity.fromUserEntity(
                      widget.user,
                      widget.profilePictureUrl,
                    ),
                    gym: widget.gym,
                  ),
                  initialPassword: widget.password,
                ),
              ),
              (_) => false,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => StyledScaffold(body: Container());

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
