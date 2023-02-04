part of registration_page;

class _PageFourLoading extends StatelessWidget {
  const _PageFourLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            40.verticalSpace,
            StyledBackButton(),
            Expanded(
              child: Column(
                children: [
                  180.verticalSpace,
                  Text(
                    "Getting you started...",
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  40.verticalSpace,
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PageFourError extends _PageFourBase {
  final String error;

  _PageFourError({
    Key? key,
    required GymEntity gym,
    required VoidCallback onPressedYes,
    required VoidCallback onPressedNo,
    required this.error,
  }) : super(
          key: key,
          gym: gym,
          onPressedYes: onPressedYes,
          onPressedNo: onPressedNo,
          buttonText: "RETRY",
          child: Text(
            error,
            style: theme.textTheme.labelLarge!.copyWith(
              color: theme.errorColor,
            ),
            textAlign: TextAlign.center,
          ),
        );
}

class _PageFour extends _PageFourBase {
  _PageFour({
    Key? key,
    required GymEntity gym,
    required VoidCallback onPressedYes,
    required VoidCallback onPressedNo,
  }) : super(
          key: key,
          gym: gym,
          onPressedYes: onPressedYes,
          onPressedNo: onPressedNo,
          buttonText: "YES",
        );
}

class _PageFourBase extends StatelessWidget {
  final GymEntity gym;
  final VoidCallback onPressedYes;
  final VoidCallback onPressedNo;
  final Widget? child;
  final String buttonText;

  const _PageFourBase({
    Key? key,
    required this.gym,
    required this.onPressedYes,
    required this.onPressedNo,
    required this.buttonText,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          120.verticalSpace,
          Text(
            "Is this your\nfitness club?",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          Text(
            gym.name,
            style: theme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          Text(
            gym.address.toString(),
            style: theme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          100.verticalSpace,
          child ?? Container(),
          20.verticalSpace,
          StyledButton(
            onPressed: onPressedYes,
            text: buttonText,
          ),
          Spacer(),
          StyledUnderlinedTextButton(
            text: "NO, IT'S NOT",
            onPressed: onPressedNo,
          ),
          32.verticalSpace,
        ],
      );
}
