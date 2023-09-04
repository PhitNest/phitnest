import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../../../repositories/repositories.dart';

part 'bloc.dart';

final class InviteForm extends StatelessWidget {
  final void Function(BuildContext) onSessionLost;

  void handleStateChanged(
    BuildContext context,
    InviteFormControllers controllers,
    LoaderState<AuthResOrLost<HttpResponse<void>>> loaderState,
  ) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        switch (response) {
          case AuthRes(data: final data):
            switch (data) {
              case HttpResponseSuccess():
                StyledBanner.show(
                  message: 'Invite sent',
                  error: false,
                );
                controllers.emailController.clear();
              case HttpResponseFailure(failure: final failure):
                StyledBanner.show(
                  message: failure.message,
                  error: true,
                );
            }
          case AuthLost():
            onSessionLost(context);
        }
      default:
    }
  }

  const InviteForm({
    super.key,
    required this.onSessionLost,
  }) : super();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: _inviteForm(
          (context, controllers, submit) => AuthLoaderConsumer(
            listener: (context, loaderState) =>
                handleStateChanged(context, controllers, loaderState),
            builder: (context, loaderState) {
              void handleSubmit() => submit(
                    AuthReq(
                      controllers.emailController.text,
                      context.sessionLoader,
                    ),
                    loaderState,
                  );
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Invite'),
                  12.verticalSpace,
                  StyledUnderlinedTextField(
                    hint: 'Email',
                    validator: EmailValidator.validateEmail,
                    controller: controllers.emailController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => handleSubmit(),
                  ),
                  switch (loaderState) {
                    LoaderLoadingState() => const Loader(),
                    _ => TextButton(
                        onPressed: handleSubmit,
                        child: const Text('Invite'),
                      ),
                  },
                ],
              );
            },
          ),
        ),
      );
}
