import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

final class InviteParams extends Equatable {
  final String email;
  final String gymId;

  const InviteParams({
    required this.email,
    required this.gymId,
  }) : super();

  @override
  List<Object?> get props => [email, gymId];

  Map<String, dynamic> toJson() => {
        'receiverEmail': email,
        'gymId': gymId,
      };
}

Future<HttpResponse<void>> invite({
  required InviteParams params,
  required Session session,
}) =>
    request(
      route: '/adminInvite',
      method: HttpMethod.post,
      parser: (_) {},
      data: params.toJson(),
      session: session,
    );

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
  final void Function(BuildContext) onSessionLost;

  const InviteForm({
    super.key,
    required this.onSessionLost,
  }) : super();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: FormProvider<InviteFormControllers, InviteParams,
            HttpResponse<void>?>(
          createControllers: (_) => InviteFormControllers(),
          load: (params) => context.sessionLoader.session.then(
            (session) {
              if (session != null) {
                return invite(
                  params: params,
                  session: session,
                );
              } else {
                return null;
              }
            },
          ),
          formBuilder: (context, controllers, consumer) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Invite'),
              StyledUnderlinedTextField(
                hint: 'Email',
                validator: EmailValidator.validateEmail,
                controller: controllers.emailController,
              ),
              StyledUnderlinedTextField(
                hint: 'Gym ID',
                controller: controllers.gymIdController,
              ),
              consumer(
                listener: (context, submitState, _) {
                  switch (submitState) {
                    case LoaderLoadedState(data: final response):
                      if (response != null) {
                        switch (response) {
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
                      } else {
                        onSessionLost(context);
                      }
                    default:
                  }
                },
                builder: (context, submitState, submit) =>
                    switch (submitState) {
                  LoaderLoadedState() || LoaderInitialState() => TextButton(
                      onPressed: () => submit(
                        InviteParams(
                          email: controllers.emailController.text,
                          gymId: controllers.gymIdController.text,
                        ),
                      ),
                      child: const Text('Invite'),
                    ),
                  LoaderLoadingState() => const CircularProgressIndicator(),
                },
              )
            ],
          ),
        ),
      );
}
