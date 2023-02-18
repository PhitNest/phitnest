part of app;

class _RedirectHome extends StatefulWidget {
  /// This is used to redirect to the home page from the root of [App].
  const _RedirectHome({
    Key? key,
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
                builder: (context) => HomePage(),
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
