import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'confirm_photo_state.dart';
import 'confirm_photo_view.dart';

class ConfirmPhotoProvider
    extends ScreenProvider<ConfirmPhotoState, ConfirmPhotoView> {
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
  ConfirmPhotoView build(BuildContext context, ConfirmPhotoState state) =>
      ConfirmPhotoView(
        onPressedConfirm: () {
          state.errorMessage = null;
          state.loading = true;
          registerUseCase
              .register(
            this.email,
            this.password,
            this.firstName,
            this.lastName,
          )
              .then(
            (failure) {
              if (state.disposed) return;
              state.loading = false;
              if (failure != null) {
                if (failure.message.toLowerCase().contains('email') ||
                    failure.message.toLowerCase().contains('password')) {
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..push(
                      NoAnimationMaterialPageRoute(
                        builder: (context) => RegisterPageTwoProvider(
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          password: password,
                          errorMessage: failure.message,
                        ),
                      ),
                    );
                } else {
                  state.errorMessage = failure.message;
                }
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  NoAnimationMaterialPageRoute(
                    builder: (context) => ConfirmEmailProvider(
                      onPressedBack: () => Navigator.pushAndRemoveUntil(
                        context,
                        NoAnimationMaterialPageRoute(
                          builder: (context) => LoginProvider(),
                        ),
                        (_) => false,
                      ),
                      confirmVerification: (code) => confirmRegisterUseCase
                          .confirmRegister(email, code)
                          .then(
                        (value) {
                          if (value == null) {
                            deviceCacheRepo.setEmail(email);
                            deviceCacheRepo.setPassword(password);
                            memoryCacheRepo.email = email;
                            memoryCacheRepo.password = password;
                            Navigator.of(context).pushAndRemoveUntil(
                              NoAnimationMaterialPageRoute(
                                builder: (context) => ReviewingPhotoProvider(
                                  name: '$firstName $lastName',
                                ),
                              ),
                              (_) => false,
                            );
                          }
                          return value;
                        },
                      ),
                      resendConfirmation: () =>
                          confirmRegisterUseCase.resendConfirmation(email),
                    ),
                  ),
                  (_) => false,
                );
              }
            },
          );
        },
        onPressedRetake: () {},
        loading: state.loading,
        errorMessage: state.errorMessage,
      );

  @override
  ConfirmPhotoState buildState() => ConfirmPhotoState();
}
