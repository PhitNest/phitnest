import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/confirm_email_bloc.dart';
import '../event/confirm_email_event.dart';
import '../state/confirm_email_state.dart';
import 'widgets/error.dart';
import 'widgets/initial.dart';
import 'widgets/loading.dart';

ConfirmEmailBloc _bloc(BuildContext context) => context.read();

void _onPressedResend(BuildContext context) =>
    _bloc(context).add(const ResendCodeEvent());

void _onCompleted(BuildContext context) => _bloc(context).add(SubmitEvent());

class ConfirmEmailPage extends StatelessWidget {
  final String email;
  final String password;
  final VoidCallback onConfirmed;

  const ConfirmEmailPage({
    Key? key,
    required this.email,
    required this.password,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => ConfirmEmailBloc(),
        child: BlocConsumer<ConfirmEmailBloc, ConfirmEmailState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ErrorState) {
              return ConfirmEmailError(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                email: email,
                onChanged: () {},
                onCompleted: () => _onCompleted(context),
                onPressedResend: () => _onPressedResend(context),
                error: state.failure,
              );
            } else if (state is LoadingState) {
              return ConfirmEmailLoading(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                email: email,
                onChanged: () {},
                onCompleted: () {},
              );
            } else if (state is InitialState) {
              return ConfirmEmailInitial(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                email: email,
                onChanged: () {},
                onCompleted: () => _onCompleted(context),
                onPressedResend: () => _onPressedResend(context),
              );
            } else {
              throw Exception('Invalid state: $state');
            }
          },
        ),
      );
}
