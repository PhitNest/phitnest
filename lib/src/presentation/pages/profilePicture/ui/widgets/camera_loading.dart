part of profile_picture_page;

class _CameraLoadingPage extends _ICameraLoadingPage {
  const _CameraLoadingPage({
    Key? key,
  }) : super(
          key: key,
          child: const CircularProgressIndicator(),
        );
}

abstract class _ICameraLoadingPage extends StatelessWidget {
  final Widget child;

  const _ICameraLoadingPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            StyledBackButton(),
            160.verticalSpace,
            child,
          ],
        ),
      );
}
