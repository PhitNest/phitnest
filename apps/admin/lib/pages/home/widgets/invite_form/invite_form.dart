import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../../../../entities/entities.dart';
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
            builder: (context, loaderState) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Invite'),
                StyledUnderlinedTextField(
                  hint: 'Email',
                  validator: EmailValidator.validateEmail,
                  controller: controllers.emailController,
                  textInputAction: TextInputAction.next,
                ),
                StyledUnderlinedTextField(
                  hint: 'Gym ID',
                  controller: controllers.gymIdController,
                  textInputAction: TextInputAction.done,
                ),
                switch (loaderState) {
                  LoaderLoadingState() => const Loader(),
                  _ => TextButton(
                      onPressed: () => submit(
                        AuthReq(
                          InviteParams.populated(
                            receiverEmail: controllers.emailController.text,
                            gymId: controllers.gymIdController.text,
                          ),
                          context.sessionLoader,
                        ),
                        loaderState,
                      ),
                      child: const Text('Invite'),
                    ),
                },
              ],
            ),
          ),
        ),
      );
}
