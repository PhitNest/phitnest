import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/entities.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';

class LoadingView extends StatelessWidget {
  final GlobalKey navbarKey;

  const LoadingView({
    required this.navbarKey,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            220.verticalSpace,
            CircularProgressIndicator(),
            Spacer(),
            StyledNavBar(
              page: NavbarPage.explore,
              gestureKey: navbarKey,
            )
          ],
        ),
      );
}

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onPressedRetry;
  final GlobalKey navbarKey;

  const ErrorView({
    required this.errorMessage,
    required this.onPressedRetry,
    required this.navbarKey,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            200.verticalSpace,
            Text(
              errorMessage,
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            StyledButton(
              onPressed: onPressedRetry,
              child: Text('RETRY'),
            ),
            Spacer(),
            StyledNavBar(
              page: NavbarPage.explore,
              gestureKey: navbarKey,
            )
          ],
        ),
      );
}

class HoldingView extends _BaseWidget {
  const HoldingView({
    required super.users,
    required super.onChangePage,
    required super.onReleaseLogo,
    required super.countdown,
    required super.navbarKey,
    required super.pageViewKey,
  }) : super(animateLogo: false);
}

class LoadedView extends _BaseWidget {
  const LoadedView({
    required super.users,
    required super.onChangePage,
    required super.onPressedLogo,
    required super.navbarKey,
    required super.pageViewKey,
  }) : super(animateLogo: true);
}

class _BaseWidget extends StatelessWidget {
  final List<ExploreUserEntity> users;
  final void Function(int pageIndex) onChangePage;
  final VoidCallback? onPressedLogo;
  final VoidCallback? onReleaseLogo;
  final bool animateLogo;
  final int? countdown;
  final GlobalKey navbarKey;
  final GlobalKey pageViewKey;

  const _BaseWidget({
    required this.users,
    required this.onChangePage,
    required this.animateLogo,
    required this.navbarKey,
    required this.pageViewKey,
    this.countdown,
    this.onPressedLogo,
    this.onReleaseLogo,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        darkMode: false,
        body: Column(
          children: [
            Flexible(
              child: PageView.builder(
                key: pageViewKey,
                onPageChanged: onChangePage,
                itemBuilder: (context, index) => _ExploreCard(
                  countdown: countdown,
                  fullName: users[index % users.length].fullName,
                ),
              ),
            ),
            Text(
              'Press and hold logo to send friend request',
              style: theme.textTheme.bodySmall,
            ),
            20.verticalSpace,
            StyledNavBar(
              gestureKey: navbarKey,
              page: NavbarPage.explore,
              colorful: true,
              onPressDownLogo: onPressedLogo,
              onReleaseLogo: onReleaseLogo,
              animateLogo: animateLogo,
            )
          ],
        ),
      );
}

class EmptyNestView extends StatelessWidget {
  final GlobalKey navbarKey;

  const EmptyNestView({
    required this.navbarKey,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            200.verticalSpace,
            Text(
              "More friends\nare on the way.",
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            40.verticalSpace,
            Text(
              "The nest is still growing! Please\ncheck again later.",
              style: theme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            StyledNavBar(
              page: NavbarPage.explore,
              gestureKey: navbarKey,
            ),
          ],
        ),
      );
}

class _ExploreCard extends StatelessWidget {
  final String fullName;
  final int? countdown;

  const _ExploreCard({
    required this.fullName,
    required this.countdown,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 375.w,
                height: 333.h,
                child: Image.asset(
                  'assets/images/selfie.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 40.h),
                alignment: Alignment.topCenter,
                child: countdown != null
                    ? CountdownRing(
                        countdownNum: max(1, countdown!),
                        dark: false,
                      )
                    : null,
              ),
            ],
          ),
          80.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              height: 120.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/left_arrow.png',
                    width: 40.w,
                  ),
                  Container(
                    width: 240.w,
                    child: Text(
                      fullName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge,
                      softWrap: true,
                    ),
                  ),
                  Image.asset(
                    'assets/images/right_arrow.png',
                    width: 40.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
