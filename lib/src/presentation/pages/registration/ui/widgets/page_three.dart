part of registration_page;

class _PageThreeLoadingError extends _PageThreeBase {
  final String error;
  final VoidCallback onPressedRetry;

  _PageThreeLoadingError({
    Key? key,
    required super.firstName,
    required super.onPressedNoGym,
    required this.error,
    required this.onPressedRetry,
  }) : super(
          key: key,
          children: [
            20.verticalSpace,
            Text(
              error,
              style:
                  theme.textTheme.labelLarge!.copyWith(color: theme.errorColor),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            StyledButton(
              text: "RETRY",
              onPressed: onPressedRetry,
            ),
          ],
        );
}

class _PageThreeNotSelected extends _PageThreeBase {
  final List<GymEntity> gyms;
  final ValueChanged<GymEntity> onSelected;

  _PageThreeNotSelected({
    Key? key,
    required super.firstName,
    required super.onPressedNoGym,
    required this.gyms,
    required this.onSelected,
  }) : super(
          key: key,
          children: [
            Text(
              "Do you belong to a fitness club?",
              style: theme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            StyledComboBox<GymEntity>(
              width: 311.w,
              height: 34.h,
              items: gyms,
              hint: 'Select your fitness club',
              labelBuilder: (item) => item.name,
              onChanged: onSelected,
            ),
          ],
        );
}

class _PageThreeSelected extends _PageThreeBase {
  final List<GymEntity> gyms;
  final GymEntity gym;
  final ValueChanged<GymEntity> onSelected;
  final VoidCallback onPressedNext;

  _PageThreeSelected({
    Key? key,
    required super.firstName,
    required super.onPressedNoGym,
    required this.gyms,
    required this.gym,
    required this.onSelected,
    required this.onPressedNext,
  }) : super(
          key: key,
          children: [
            Text(
              "Do you belong to a fitness club?",
              style: theme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            StyledComboBox<GymEntity>(
              width: 311.w,
              height: 34.h,
              items: gyms,
              hint: 'Select your fitness club',
              labelBuilder: (item) => item.name,
              onChanged: onSelected,
              initialValue: gym,
            ),
            24.verticalSpace,
            StyledButton(
              onPressed: onPressedNext,
              text: "NEXT",
            ),
          ],
        );
}

class _PageThreeLoading extends _PageThreeBase {
  _PageThreeLoading({
    Key? key,
    required super.firstName,
    required super.onPressedNoGym,
  }) : super(
          key: key,
          children: [
            Text(
              "Loading fitness clubs...",
              style: theme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            CircularProgressIndicator(),
          ],
        );
}

class _PageThreeBase extends StatelessWidget {
  final String firstName;
  final VoidCallback onPressedNoGym;
  final List<Widget> children;

  const _PageThreeBase({
    Key? key,
    required this.firstName,
    required this.onPressedNoGym,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          120.verticalSpace,
          Text(
            "Let's get ready\nto meet people,\n$firstName.",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          Expanded(
            child: Column(
              children: [
                ...children,
                Spacer(),
                StyledUnderlinedTextButton(
                  text: "I DON'T BELONG TO A FITNESS CLUB",
                  onPressed: onPressedNoGym,
                ),
                32.verticalSpace,
              ],
            ),
          ),
        ],
      );
}
