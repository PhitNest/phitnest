part of profile_picture_page;

class _CameraLoadingPage extends _ICameraLoadingPage {
  const _CameraLoadingPage({
    Key? key,
  }) : super(
          key: key,
          child: const CircularProgressIndicator(),
        );
}

class _CameraLoadingErrorPage extends _ICameraLoadingPage {
  final String errorMessage;
  final VoidCallback onPressedRetry;

  _CameraLoadingErrorPage({
    Key? key,
    required this.errorMessage,
    required this.onPressedRetry,
  }) : super(
          key: key,
          child: Column(
            children: [
              Text(
                errorMessage,
                style: theme.textTheme.labelLarge!
                    .copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              StyledButton(
                text: 'RETRY',
                onPressed: onPressedRetry,
              ),
            ],
          ),
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
            40.verticalSpace,
            StyledBackButton(),
            160.verticalSpace,
            child,
          ],
        ),
      );
}
