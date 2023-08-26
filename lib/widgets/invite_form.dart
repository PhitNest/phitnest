import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import '../api/api.dart';

final class InviteFormControllers extends FormControllers {
  final emailController = TextEditingController();
  final gymIdController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    gymIdController.dispose();
  }
}

final class InviteForm extends StatelessWidget {
  final ApiInfo apiInfo;
  final void Function(BuildContext) onSessionLost;

  const InviteForm({
    super.key,
    required this.apiInfo,
    required this.onSessionLost,
  }) : super();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: AuthFormProvider<InviteFormControllers, AdminInviteParams,
            HttpResponse<void>>(
          createControllers: (_) => InviteFormControllers(),
          createLoader: (context) =>
              AuthLoaderBloc(apiInfo: apiInfo, load: adminInvite),
          createConsumer: (context, controllers, submit) => AuthLoaderConsumer(
            listener: (context, loaderState) {
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
            },
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
                        (
                          sessionLoader: context.sessionLoader,
                          data: AdminInviteParams.populated(
                            receiverEmail: controllers.emailController.text,
                            gymId: controllers.gymIdController.text,
                          ),
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
