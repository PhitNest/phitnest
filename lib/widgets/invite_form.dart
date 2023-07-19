import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      idToken: session.cognitoSession.idToken.jwtToken,
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

typedef InviteFormBloc = FormBloc<InviteFormControllers>;
typedef InviteFormConsumer = FormConsumer<InviteFormControllers>;
typedef InviteFormLoaderBloc = LoaderBloc<InviteParams, HttpResponse<void>?>;
typedef InviteFormLoaderConsumer
    = LoaderConsumer<InviteParams, HttpResponse<void>?>;

extension on BuildContext {
  InviteFormBloc get inviteFormBloc => BlocProvider.of(this);
  InviteFormLoaderBloc get inviteFormLoaderBloc => loader();
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
        child: BlocProvider<InviteFormBloc>(
          create: (_) => InviteFormBloc(InviteFormControllers()),
          child: InviteFormConsumer(
            listener: (context, formState) {},
            builder: (context, formState) => Form(
              key: context.inviteFormBloc.formKey,
              autovalidateMode: formState.autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Invite'),
                  StyledUnderlinedTextField(
                    hint: 'Email',
                    validator: EmailValidator.validateEmail,
                    controller:
                        context.inviteFormBloc.controllers.emailController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'Gym ID',
                    controller:
                        context.inviteFormBloc.controllers.gymIdController,
                  ),
                  BlocProvider(
                    create: (context) => InviteFormLoaderBloc(
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
                    ),
                    child: InviteFormLoaderConsumer(
                      listener: (context, submitState) {
                        switch (submitState) {
                          case LoaderLoadedState(data: final response):
                            if (response != null) {
                              switch (response) {
                                case HttpResponseSuccess():
                                  StyledBanner.show(
                                    message: 'Invite sent',
                                    error: false,
                                  );
                                case HttpResponseFailure(
                                    failure: final failure
                                  ):
                                  StyledBanner.show(
                                    message: failure.message,
                                    error: true,
                                  );
                              }
                              final inviteFormBloc = context.inviteFormBloc;
                              inviteFormBloc.controllers.emailController
                                  .clear();
                              inviteFormBloc.controllers.gymIdController
                                  .clear();
                            } else {
                              onSessionLost(context);
                            }
                          default:
                        }
                      },
                      builder: (context, submitState) => switch (submitState) {
                        LoaderLoadedState() ||
                        LoaderInitialState() =>
                          TextButton(
                            onPressed: () {
                              final inviteFormBloc = context.inviteFormBloc;
                              inviteFormBloc.submit(
                                onAccept: () =>
                                    context.inviteFormLoaderBloc.add(
                                  LoaderLoadEvent(
                                    InviteParams(
                                      email: inviteFormBloc
                                          .controllers.emailController.text,
                                      gymId: inviteFormBloc
                                          .controllers.gymIdController.text,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text('Invite'),
                          ),
                        LoaderLoadingState() =>
                          const CircularProgressIndicator(),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
