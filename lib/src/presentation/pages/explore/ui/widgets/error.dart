part of explore_page;

class _ErrorPage extends StatelessWidget {
  final Failure failure;
  final VoidCallback onPressedRetry;

  const _ErrorPage({
    required this.failure,
    required this.onPressedRetry,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            failure.message,
            style: theme.textTheme.labelLarge!
                .copyWith(color: theme.colorScheme.error),
            textAlign: TextAlign.center,
          ),
          20.verticalSpace,
          StyledButton(text: "RETRY", onPressed: onPressedRetry),
        ],
      );
}
