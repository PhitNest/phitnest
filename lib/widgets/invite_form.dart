import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

extension GetInviteFormBloc on BuildContext {
  InviteFormBloc get inviteFormBloc => BlocProvider.of(this);
}

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
        'email': email,
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
      authorization: session,
    );

final class InviteFormState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const InviteFormState(this.autovalidateMode);

  @override
  List<Object?> get props => [autovalidateMode];
}

final class InviteFormRejectedEvent extends Equatable {
  const InviteFormRejectedEvent();

  @override
  List<Object?> get props => [];
}

final class InviteFormBloc
    extends Bloc<InviteFormRejectedEvent, InviteFormState> {
  final emailController = TextEditingController();
  final gymIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  InviteFormBloc() : super(const InviteFormState(AutovalidateMode.disabled)) {
    on<InviteFormRejectedEvent>(
      (event, emit) => emit(
        const InviteFormState(AutovalidateMode.always),
      ),
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    gymIdController.dispose();
    return super.close();
  }
}

final class InviteForm extends StatelessWidget {
  final Session session;

  void submit(BuildContext context) {
    final inviteFormBloc = context.inviteFormBloc;
    if (inviteFormBloc.formKey.currentState!.validate()) {
      context.loader<InviteParams, HttpResponse<void>>().add(
            LoaderLoadEvent(
              InviteParams(
                email: context.inviteFormBloc.emailController.text,
                gymId: context.inviteFormBloc.gymIdController.text,
              ),
            ),
          );
    } else {
      inviteFormBloc.add(const InviteFormRejectedEvent());
    }
  }

  const InviteForm({
    super.key,
    required this.session,
  }) : super();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<InviteFormBloc>(
              create: (_) => InviteFormBloc(),
            ),
            BlocProvider(
              create: (_) => LoaderBloc<InviteParams, HttpResponse<void>>(
                load: (params) => invite(
                  params: params,
                  session: session,
                ),
              ),
            ),
          ],
          child: BlocConsumer<InviteFormBloc, InviteFormState>(
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
                    controller: context.inviteFormBloc.emailController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'Gym ID',
                    controller: context.inviteFormBloc.gymIdController,
                  ),
                  LoaderConsumer<InviteParams, HttpResponse<void>>(
                    listener: (context, submitState) {
                      switch (submitState) {
                        case LoaderLoadedState(data: final response):
                          switch (response) {
                            case HttpResponseSuccess():
                              StyledBanner.show(
                                message: 'Invite sent',
                                error: false,
                              );
                            case HttpResponseFailure(failure: final failure):
                              StyledBanner.show(
                                message: failure.message,
                                error: true,
                              );
                          }
                          context.inviteFormBloc.emailController.clear();
                          context.inviteFormBloc.gymIdController.clear();
                        default:
                      }
                    },
                    builder: (context, submitState) => switch (submitState) {
                      LoaderLoadedState() || LoaderInitialState() => TextButton(
                          onPressed: () => submit(context),
                          child: const Text('Invite'),
                        ),
                      LoaderLoadingState() => const CircularProgressIndicator(),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
