import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class InitialView extends StatelessWidget {
  const InitialView() : super();

  @override
  Widget build(BuildContext context) =>
      BetterScaffold(body: Center(child: CircularProgressIndicator()));
}

class OnBoardingView extends StatelessWidget {
  final VoidCallback onPressedYes;

  const OnBoardingView({
    required this.onPressedYes,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: PageView(
          children: [
            _FirstPage(),
            _SecondPage(),
            _ThirdPage(
              onPressedYes: onPressedYes,
            )
          ],
        ),
      );
}

class _BaseWidget extends StatelessWidget {
  final List<Widget> children;
  final String header;
  final String subText;

  const _BaseWidget({
    required this.children,
    required this.header,
    required this.subText,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          200.verticalSpace,
          Text(
            header,
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          35.verticalSpace,
          Text(
            subText,
            style: theme.textTheme.labelLarge!.copyWith(height: 1.56),
            textAlign: TextAlign.center,
          ),
          ...children,
        ],
      );
}

class _FirstPage extends _BaseWidget {
  _FirstPage()
      : super(
          header: 'Welcome to the Nest.',
          subText: 'This is the beginning of\na beautiful friendship.',
          children: [
            Spacer(),
            RedArrowWidget(),
            51.verticalSpace,
          ],
        );
}

class _SecondPage extends _BaseWidget {
  _SecondPage()
      : super(
          header: 'Nest = fitness club',
          subText:
              'This is a positive space for you to\nexplore your health & wellness\ngoals through genuine\nconnections in your community.',
          children: [
            Spacer(),
            RedArrowWidget(),
            51.verticalSpace,
          ],
        );
}

class _ThirdPage extends _BaseWidget {
  final Function() onPressedYes;

  _ThirdPage({
    required this.onPressedYes,
  }) : super(
          header: "Let's get started",
          subText:
              'Do you belong to a fitness club?',
          children: [
            35.verticalSpace,
            StyledButton(
              child: Text('YES'),
              onPressed: onPressedYes,
            ),
          ],
        );
}
