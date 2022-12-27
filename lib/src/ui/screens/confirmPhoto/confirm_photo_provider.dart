import 'package:flutter/material.dart';

import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'confirm_photo_state.dart';
import 'confirm_photo_view.dart';

class ConfirmPhotoProvider
    extends ScreenProvider<ConfirmPhotoCubit, ConfirmPhotoState> {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const ConfirmPhotoProvider({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  }) : super();

  @override
  ConfirmPhotoCubit buildCubit() => ConfirmPhotoCubit();

  @override
  Future<void> listener(
    BuildContext context,
    ConfirmPhotoCubit cubit,
    ConfirmPhotoState state,
  ) async {
    if (state is LoadingState) {
      registerUseCase
          .register(
        email.trim(),
        password,
        firstName.trim(),
        lastName.trim(),
      )
          .then(
        (failure) {
          if (failure != null) {
            cubit.transitionToError(failure.message);
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              NoAnimationMaterialPageRoute(
                builder: (context) => ConfirmEmailProvider(
                  confirmVerification: (code) => confirmRegisterUseCase
                      .confirmRegister(email.trim(), code),
                  resendConfirmation: () =>
                      confirmRegisterUseCase.resendConfirmation(email.trim()),
                ),
              ),
              (_) => false,
            );
          }
        },
      );
    } else if (state is ErrorState) {
      if (state.message.toLowerCase().contains('email')) {
        Navigator.of(context)
          ..pop()
          ..pop()
          ..pop()
          ..push(
            NoAnimationMaterialPageRoute(
              builder: (context) => RegisterPageTwoProvider(
                firstName: firstName,
                lastName: lastName,
                initialEmail: email,
                initialPassword: password,
                initialErrorMessage: state.message,
              ),
            ),
          );
      }
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ConfirmPhotoCubit cubit,
    ConfirmPhotoState state,
  ) {
    if (state is LoadingState) {
      return LoadingView();
    } else if (state is ErrorState) {
      return ErrorView(
        errorMessage: state.message,
        onPressedRetry: () => cubit.transitionToLoading(),
        onPressedRetake: () => cubit.transitionToLoading(),
      );
    } else if (state is InitialState) {
      return InitialView(
        onPressedConfirm: () => cubit.transitionToLoading(),
        onPressedRetake: () => cubit.transitionToLoading(),
      );
    } else {
      throw Exception('Unknown State: $state');
    }
  }
}
