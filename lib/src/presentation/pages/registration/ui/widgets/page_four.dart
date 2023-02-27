part of registration_page;

class _PageFourLoading extends _PageFourBase {
  const _PageFourLoading({
    Key? key,
    required GymEntity gym,
  }) : super(
          key: key,
          gym: gym,
          child: const CircularProgressIndicator(),
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
          child: Expanded(
            child: Column(
              children: [
                20.verticalSpace,
                StyledButton(
                  onPressed: onPressedYes,
                  text: "YES",
                ),
                Spacer(),
                StyledUnderlinedTextButton(
                  text: "NO, IT'S NOT",
                  onPressed: onPressedNo,
                ),
                32.verticalSpace,
              ],
            ),
          ),
        );
}

class _PageFourBase extends StatelessWidget {
  final GymEntity gym;
  final Widget child;

  const _PageFourBase({
    Key? key,
    required this.gym,
    required this.child,
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
          130.verticalSpace,
          child,
        ],
      );
}
