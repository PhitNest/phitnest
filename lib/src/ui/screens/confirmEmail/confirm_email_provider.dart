import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'confirm_email_state.dart';
import 'confirm_email_view.dart';

class ConfirmEmailProvider
    extends ScreenProvider<ConfirmEmailCubit, ConfirmEmailState> {
  final Future<Failure?> Function(String code, String email)
      confirmVerification;
  final Future<Failure?> Function(String email) resendConfirmation;
  final String email;

  const ConfirmEmailProvider({
    required this.confirmVerification,
    required this.email,
    required this.resendConfirmation,
  }) : super();

  void onPressedResend(
    ConfirmEmailCubit cubit,
    BuildContext context,
  ) {
    cubit.transitionToLoading();
    resendConfirmation(email).then(
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
    confirmVerification(code, email).then(
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
  Future<void> listener(BuildContext context, ConfirmEmailCubit cubit,
      ConfirmEmailState state) async {
    if (state is InitialState) {
      memoryCacheRepo.triedConfirmRegister = true;
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ConfirmEmailCubit cubit,
    ConfirmEmailState state,
  ) {
    if (state is LoadingState) {
      return LoadingView(email: email);
    } else if (state is ErrorState) {
      return ErrorView(
        email: email,
        errorMessage: state.message,
        onPressedResend: () => onPressedResend(cubit, context),
        onCompletedVerification: (code) =>
            onCompleteVerification(code, cubit, context),
      );
    } else if (state is InitialState) {
      return InitialView(
        email: email,
        onPressedResend: () => onPressedResend(cubit, context),
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
