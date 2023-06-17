import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets.dart';
import 'bloc/bloc.dart';

class InviteForm extends StatelessWidget {
  final String authorization;

  const InviteForm({
    super.key,
    required this.authorization,
  }) : super();

  @override
  Widget build(BuildContext context) => BlocProvider<InviteFormBloc>(
        create: (_) => InviteFormBloc(authorization),
        child: BlocConsumer<InviteFormBloc, InviteFormState>(
          listener: (context, state) {
            switch (state) {
              case InviteFormSuccessState():
                StyledBanner.show(
                  message: 'Invite sent',
                  error: false,
                );
                context.inviteFormBloc.emailController.clear();
                context.inviteFormBloc.gymIdController.clear();
              case InviteFormFailureState(failure: final failure):
                StyledBanner.show(
                  message: failure.message,
                  error: true,
                );
              default:
            }
          },
          builder: (context, state) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Invite'),
                StyledUnderlinedTextField(
                  hint: 'Email',
                  controller: context.inviteFormBloc.emailController,
                ),
                StyledUnderlinedTextField(
                  hint: 'Gym ID',
                  controller: context.inviteFormBloc.gymIdController,
                ),
                switch (state) {
                  InviteFormInitialState() ||
                  InviteFormSuccessState() ||
                  InviteFormFailureState() =>
                    TextButton(
                      onPressed: () => context.inviteFormBloc
                          .add(const InviteFormSubmitEvent()),
                      child: const Text('Invite'),
                    ),
                  InviteFormLoadingState() => const CircularProgressIndicator(),
                },
              ],
            ),
          ),
        ),
      );
}
