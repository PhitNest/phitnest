import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/entities.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onPressedRetry;

  const ErrorView({
    required this.errorMessage,
    required this.onPressedRetry,
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
            StyledNavBar(page: NavbarPage.explore)
          ],
        ),
      );
}

class InitialView extends StatelessWidget {
  const InitialView() : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            220.verticalSpace,
            CircularProgressIndicator(),
            Spacer(),
            StyledNavBar(page: NavbarPage.chat)
          ],
        ),
      );
}

class LoadedView extends StatelessWidget {
  final UserEntity user;
  final GymEntity gym;

  const LoadedView({
    required this.user,
    required this.gym,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            Image.asset(
              'assets/images/phitnestSelfie.png',
              height: 280.h,
              width: 1.sw,
              fit: BoxFit.cover,
            ),
            40.verticalSpace,
            Text(
              user.fullName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            32.verticalSpace,
            Text(
              user.email,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Divider(
              thickness: 1,
              indent: 32.w,
              endIndent: 32.w,
            ),
            24.verticalSpace,
            Text(
              '${gym.name}, ${gym.address.city}, ${gym.address.state}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Divider(
              thickness: 1,
              indent: 32.w,
              endIndent: 32.w,
            ),
            Spacer(),
            StyledNavBar(page: NavbarPage.options),
          ],
        ),
      );
}
