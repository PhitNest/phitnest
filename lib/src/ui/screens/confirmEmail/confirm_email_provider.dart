import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'confirm_email_state.dart';
import 'confirm_email_view.dart';

class ConfirmEmailProvider
    extends ScreenProvider<ConfirmEmailCubit, ConfirmEmailState> {
  final Future<Failure?> Function(String code) confirmVerification;
  final Future<Failure?> Function() resendConfirmation;

  const ConfirmEmailProvider({
    required this.confirmVerification,
    required this.resendConfirmation,
  }) : super();

  void onResend(
    ConfirmEmailCubit cubit,
    BuildContext context,
  ) {
    cubit.transitionToLoading();
    resendConfirmation().then(
      (failure) {
        if (failure != null) {
          cubit.transitionToError(failure.message);
        } else {
          cubit.transitionToInitial();
        }
      },
    );
  }

  void onCompleteVerification(
    String code,
    ConfirmEmailCubit cubit,
    BuildContext context,
  ) {
    cubit.transitionToLoading();
    confirmVerification(code).then(
      (failure) {
        if (failure != null) {
          cubit.transitionToError(failure.message);
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(
              builder: (context) => ExploreProvider(),
            ),
            (_) => false,
          );
        }
      },
    );
  }

  @override
  Widget builder(
    BuildContext context,
    ConfirmEmailCubit cubit,
    ConfirmEmailState state,
  ) {
    if (state is LoadingState) {
      return LoadingView();
    } else if (state is ErrorState) {
      return ErrorView(
        errorMessage: state.message,
        onPressedResend: () => onResend(cubit, context),
        onCompletedVerification: (code) =>
            onCompleteVerification(code, cubit, context),
      );
    } else if (state is InitialState) {
      return InitialView(
        onPressedResend: () => onResend(cubit, context),
        onCompletedVerification: (code) =>
            onCompleteVerification(code, cubit, context),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  ConfirmEmailCubit buildCubit() => ConfirmEmailCubit();
}
